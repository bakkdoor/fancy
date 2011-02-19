require: "binding"

MatchFailure = Binding new: nil

class Object {
  def case_of: pattern otherwise: fail_block ({ "Pattern Failed!" raise! }) {
    bind = pattern does_match: self else: { Binding new }
    if: (bind bound?) then: {
      bind value
    } else: {
      pattern match_failed_for: self escape: fail_block
    }
  }
}

class Pattern {
  @@registry = <[]>

  def Pattern register: pattern_class for: literal_class {
    @@registry at: literal_class put: pattern_class
  }

  def Pattern literal: lit {
    @@registry[lit class] new: lit
  }

  def Pattern wildcard {
    WildcardPattern # defined below
  }

  def match_failed_for: val escape: block {
    block call: [val]
  }

  def Pattern keywords: keywords patterns: patterns {
    # TODO
    nil
  }

  def initialize: @closure {
  }

  def does_match: value else: block {
    if: @closure then: {
      @closure call: [value, block]
    } else: {
      "Don't know how to match!" raise!
    }
  }

  def not {
    # TODO
  }

  def ->> closure {
    PatternApplication new: self with: closure
  }

  def || alternative_pattern {
    PatternDisjunction new: self with: alternative_pattern
  }
}

WildcardPattern = Pattern new: |value fail_block| {
  Binding new: value # always match
}

class PatternApplication : Pattern {
  def initialize: @pattern with: @closure {
  }

  def does_match: val else: fail_block {
    bind = @pattern does_match: val else: { MatchFailure }
    if: (bind == MatchFailure) then: {
      match_failed_for: val escape: fail_block
    } else: {
      proxy = ProxyReceiver new: bind for: $ @closure receiver
      result = @closure call: [bind] with_receiver: proxy
      Binding new: result
    }
  }
}

class PatternDisjunction : Pattern {
  def initialize: @pattern with: @alternative {
  }

  def does_match: val else: fail_block {
    @pattern does_match: val else: {
      @alternative does_match: val else: fail_block
    }
  }
}

class EqualityPattern : Pattern {
  def initialize: @value {
  }

  def does_match: val else: block {
    if: (val == @value) then: {
      Binding new: @value
    } else: {
      block call: [MatchFailure]
    }
  }
}

class NumberPattern : EqualityPattern {
  Pattern register: self for: Fixnum
  Pattern register: self for: Float
}

class StringPattern : EqualityPattern {
  Pattern register: self for: String
}