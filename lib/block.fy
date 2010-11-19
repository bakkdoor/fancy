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

    { self call not } while_true: block
  }

  def while_nil: block {
    "Same as Block#while_false:"

    while_false: block
  }

  alias_method: 'while_do: for: 'while_true:

  def until_do: block {
    """
    Calls a given Block as long as @self returns @nil or @false.
    """

    loop: {
      self call if_do: |val| {
        return val
      } else: {
        block call
      }
    }
  }

  def && other_block {
    """
    Short-circuiting && (boolean AND).
    """

    if: (self call) then: {
      other_block call
    } else: {
      return false
    }
  }

  def || other_block {
    """
    Short-circuiting || (boolean OR).
    """

    if: (self call) then: {
      return true
    } else: {
      other_block call
    }
  }
}
