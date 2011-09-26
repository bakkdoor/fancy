class Parsing {
  class Regexp {
    def ==> action {
      Rule new: self action: action
    }

    def && other {
      match other {
        case Rule -> AndRule new: (Rule new: self) and: other
        case _ -> AndRule new: (Rule new: self) and: (Rule new: other)
      }
    }

    def optional {
      Rule new: self . optional
    }

    def min: min (0) max: max (nil) {
      Rule new: self . min: min max: max
    }

    def not {
      Rule new: self . not
    }
  }

  class Rule {
    read_write_slots: ['name, 'pattern, 'action]

    def initialize: @pattern (nil) action: @action (nil) {}

    def offset {
      @offset = @offset || 0
      @offset
    }

    def ==> action {
      clone do: {
        action: action
      }
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

    def || other_rule {
      match other_rule {
        case Rule -> OrRule new: self and: other_rule
        case _ -> OrRule new: self and: (Rule new: other_rule)
      }
    }

    def && other {
      match other {
        case Rule -> AndRule new: self and: other
        case _ -> AndRule new: self and: (Rule new: other)
      }
    }

    def not {
      NotRule new: self
    }

    def min: min (0) max: max (nil) {
      ManyRule new: self min: min max: max
    }

    def clone {
      r = Rule new: @pattern action: @action
      { r name: @name } if: @name
      r
    }

    def optional {
      ManyRule new: self min: 0
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
          @action call: [string]
          return true
      }
    }

    def clone {
      NotRule new: @rule action: @action
    }
  }

  class ManyRule : Rule {
    def initialize: @rule min: @min max: @max (nil) action: @action (nil) {
    }

    def parse: string offset: offset (0) {
      rule = @rule
      if: @max then: {
        @min upto: @max do: {
          rule = rule && @rule
        }
        rule = rule && (@rule not)
        val = rule parse: string offset: offset
        @offset = rule offset + offset
        { return @action call: [val] } if: @action
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
