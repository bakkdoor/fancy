class Parsing {
  class Regexp {
    def ==> action {
      Rule new: self action: action
    }
  }

  class Rule {
    read_write_slots: ['name, 'pattern, 'action]

    def initialize: @pattern (nil) action: @action (nil) {}

    def ==> action {
      clone do: {
        action: action
      }
    }

    def parse: string {
      match string {
        case @pattern -> |m|
          if: @action then: {
            return @action call: (m to_a)
          } else: {
            return true
          }
        case _ ->
          return false
      }
    }

    def || other_rule {
      match other_rule {
        case Rule -> OrRule new: self and: other_rule
        case _ -> OrRule new: self and: (Rule new: other_rule)
      }
    }

    def && other_rule {
      AndRule new: self and: other_rule
    }

    def not {
      NotRule new: self
    }

    def many: min (0) max: max (nil){
      ManyRule new: self min: min max: max
    }

    def clone {
      r = Rule new: @pattern action: @action
      { r name: @name } if: @name
      r
    }
  }

  class OrRule : Rule {
    def initialize: @a and: @b action: @action (nil) {}

    def parse: string {
      if: (@a parse: string || { @b parse: string }) then: |val| {
        if: @action then: {
          return @action call: [val]
        } else: {
          return val
        }
      }
    }

    def clone {
      OrRule new: @a and: @b action: @action
    }
  }

  class AndRule : Rule {
    def initialize: @a and: @b action: @action (nil) {}

    def parse: string {
      if: ((@a parse: string) && { @b parse: string }) then: |val| {
        if: @action then: {
          @action call: [val]
        } else: {
          return val
        }
      }
    }

    def clone {
      AndRule new: @a and: @b action: @action
    }
  }

  class NotRule : Rule {
    def initialize: @rule action: @action (nil) {}
    def parse: string {
      match string {
        case @rule pattern ->
          return false
        case _ ->
          @action call: [string]
          return true
      }
    }

    def clone {
      NotRule new: @rule action: @action
    }
  }

  class ManyRule : Rule {
    def initialize: @rule min: @min max: @max {
      { @max = @min } unless: @max
    }
    def parse: string {
      if: (@min == @max) then: {
        @min times: |i| {
        }
      }
    }
    def clone {
      ManyRule new: @rule min: @min max: @max
    }
  }
}

Regexp include: Parsing Regexp
