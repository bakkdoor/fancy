class Parsing {
  class Rules {
    def ==> action {
      to_rule clone do: {
        action: action
      }
    }

    def || other_rule {
      OrRule new: to_rule and: (other to_rule)
    }

    def && other {
      AndRule new: to_rule and: (other to_rule)
    }

    def optional {
      ManyRule new: to_rule min: 0
    }

    def min: min (0) max: max (nil) {
      ManyRule new: to_rule min: min max: max
    }

    def [min_max] {
      min, max = min_max
      min: min max: max
    }

    def not {
      NotRule new: to_rule
    }
  }

  class Regexp {
    include: Rules

    def to_rule {
      Rule new: self
    }
  }

  class Rule {
    include: Rules
    read_write_slots: ['name, 'pattern, 'action]

    def initialize: @pattern (nil) action: @action (nil) {}

    def to_rule {
      self
    }

    def offset {
      @offset = @offset || 0
      @offset
    }

    def parse: string offset: offset (0) {
      match string from: offset to: -1 {
        case @pattern -> |m|
          @offset = m offset: 0 . second
          if: @action then: {
            return @action call: (m to_a)
          } else: {
            return m
          }
        case _ ->
          return false
      }
    }

    def clone {
      r = Rule new: @pattern action: @action
      { r name: @name } if: @name
      r
    }
  }

  class OrRule : Rule {
    def initialize: @a and: @b action: @action (nil) {}

    def parse: string offset: offset (0) {
      if: (@a parse: string offset: offset || { @b parse: string offset: offset }) then: |val| {
        @offset = @a offset max: (@b offset)
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

    def parse: string offset: offset (0) {
      val1 = @a parse: string offset: offset
      @offset = @a offset + offset
      val2 = nil
      if: val1 then: {
        val2 = @b parse: string offset: @offset
        @offset = @b offset + @offset
      }

      if: (val1 && val2) then: |val| {
        if: @action then: {
          @action call: [val1, val2]
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

    def parse: string offset: offset (0) {
      match string from: offset to: -1 {
        case @rule pattern ->
          return false
        case _ ->
          { return @action call: [string] } if: @action
          return string
      }
    }

    def clone {
      NotRule new: @rule action: @action
    }
  }

  class ManyRule : Rule {
    read_slots: ['rule, 'min, 'max]
    def initialize: @rule min: @min max: @max (nil) action: @action (nil) {
    }

    def parse: string offset: offset (0) {
      rule = @rule
      if: @max then: {
        @min upto: @max do: {
          rule = rule && @rule
        }
        rule = rule && (@rule not)
        rule action: @action
        val = rule parse: string offset: offset
        @offset = rule offset + offset
        return val
      } else: {
        @min times: {
          rule = rule && @rule
        }
        @offset = offset
        vals = []
        while: { rule parse: string offset: @offset } do: |v| {
          @offset = rule offset + @offset
          vals << v
        }
        { return @action call: vals } if: @action
        return vals
      }
    }

    def clone {
      ManyRule new: @rule min: @min max: @max
    }
  }
}

Regexp include: Parsing Regexp
