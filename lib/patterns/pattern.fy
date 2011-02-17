require: "binding"

MatchFailure = Binding new: nil

class Pattern {
  @@registry = <[]>

  def Pattern literal: lit {
    @@registry[lit class] new: lit
  }

  def Pattern wildcard {
    WildcardPattern new
  }

  def Pattern keywords: keywords patterns: patterns {
    # TODO
    nil
  }

  def not {
    # TODO
  }

  def >> closure {
    PatternApplication new: self with: closure
  }
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

class WildcardPattern : Pattern {
  def does_match: val else: block {
    true
  }
}

class NumberPattern : Pattern {
  def initialize: @num {
  }

  def does_match: val else: block {
  }
}