class Block {
  """
  The Block class (also BlockEnvironment) is the class of all
  Block-literal values.
  A Block is a piece of unevaluated code, that can be passed around as
  any other value and evaluated by calling the +call+ or +call:+ methods.

  Blocks also work properly with their enclosing environment in that
  they preserve any local variables that get used within the Block,
  even if the context in which they got defined has been destroyed.
  => Blocks are proper closures.

  See: http://en.wikipedia.org/wiki/Closure_(computer_science) for
  more information.
  """

  def while_false: block {
    """
    Executes a given Block while self evals to nil
    Example:
      i = 0
      { i >= 10 } while_false: {
        i println
        i = i + 1
      }
    """

    { call not } while_true: block
  }

  def while_nil: block {
    "Same as Block#while_false:"

    while_false: block
  }

  def while_true: work {
    return_value = nil
    {
      call if_do: {
        work call
      } else: {
        break
      }
    } loop
  }

  alias_method: 'while_do: for: 'while_true:

  def until_do: block {
    """
    Calls a given Block as long as @self returns @nil or @false.
    """

    self while_false: block
  }

  def until: block {
    """
    Calls @self while @block yields @nil or @false.
    """

    { block call not } while_true: self
  }

  def && other_block {
    """
    Short-circuiting && (boolean AND).
    """

    if: call then: other_block else: {
      return false
    }
  }

  def || other_block {
    """
    Short-circuiting || (boolean OR).
    """

    if: call then: |val| {
      return val
    } else: other_block
  }

  def if: obj {
    "Calls itself if the given object is true-ish."

    if: obj then: self
  }

  def unless: obj {
    "Opposite of Block#if:. Calls itself if the given object is false-ish."

    unless: obj do: self
  }

  def === val {
    """
    @val Other object to match @self against.
    @return Value of calling @self with @val.

    Matches a @Block against another object by calling @self with @val.
    """

    call: [val]
  }
}

class Fancy {
  class BreakIteration : StdError {
    read_slots: ['return_value]
    def initialize: @return_value {}
  }
  class NextIteration : StdError {
    read_slots: ['return_value]
    def initialize: @return_value {}
  }
}
