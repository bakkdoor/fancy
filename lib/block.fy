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

  def while_do: block {
    """
    @block @Block@ to be called with the value of calling @self, when calling @self yields a true-ish value.

    Calls a given @Block@ while calling @self yields a true-ish value
    (everything not @nil or @false). When calling @block, passed in
    the return value of calling @self.
    In that terms, it's similar to @Object#if_do:@
    """

    val = nil
    { val = self call } while_true: {
      block call: [val]
    }
  }

  def && other_block {
    """
    Short-circuiting && (boolean AND).
    """

    self call if_true: {
      other_block call
    } else: {
      return false
    }
  }

  def || other_block {
    """
    Short-circuiting || (boolean OR).
    """

    self call if_true: {
      return true
    } else: {
      other_block call
    }
  }
}
