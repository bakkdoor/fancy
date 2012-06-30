class Matchers {
  class MatchAny {
    """
    MatchAny matcher. Matches any of the 2 values associated with it.

    Example:
          m = MatchAny new: 1 with: 2
          m === 1  # => true
          m === 2  # => true

    There's also a shorthand method defined with @Object#><@:

    Example:
          m = 1 >< 2
          m === 1  # => true
          m === 2  # => true
    """

    read_slots: ('a, 'b)
    def initialize: @a with: @b

    def === object {
      """
      @other Object to match against.
      @return @true if @objects matches either @a or @b in @self.
      """

      if: (@a === object) then: @{ return } else: {
        @b === object
      }
    }

    expose_to_ruby: '===

    def == other {
      match other {
        case MatchAny -> @a == (other a) && { @b == (other b)}
        case _ -> false
      }
    }
  }

  class MatchAll {
    """
    MatchAll matcher. Matches only if all of the 2 values associated with it match a given value.

    Example:
          m = MatchAll new: Array with: Enumerable
          m === \"foo\"  # => false
          m === [1,2,3]  # => true

    There's also a shorthand method defined with @Object#<>@:

    Example:
          (Array <> Enumerable) === [1,2,3]  # => true
    """

    read_slots: ('a, 'b)
    def initialize: @a with: @b

    def === object {
      """
      @object Object to match against.
      @return @true if it matches both @a and @b in @self.
      """

      if: (@a === object) then: { @b === object }
    }

    expose_to_ruby: '===

    def == other {
      match other {
        case MatchAll -> @a == (other a) && { @b == (other b)}
        case _ -> nil
      }
    }
  }
}
