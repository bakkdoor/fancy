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

  alias_method: 'while_nil: for: 'while_false:

  def while_true: work {
    """
    @work @Block@ to call while @self yields @true.

    Calls @work while calling @self yields a @true-ish value.
    """

    {
      call if_true: |val| {
        work call: [val]
      } else: {
        break
      }
    } loop
  }

  alias_method: 'while_do: for: 'while_true:

  def until_do: block {
    """
    @block @Block@ to be called while @self yields @nil or @false.

    Calls a given Block as long as @self yields @nil or @false.
    """

    self while_false: block
  }

  def until: block {
    """
    @block Condition @Block@ to be called to determine if @self should be called.

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
    """
    @obj Condition object to determine if @self should be called.

    Calls @self if @obj is true-ish.
    """

    if: obj then: self
  }

  def unless: obj {
    """
    @obj Condition object to determine if @self should not be called.

    Opposite of Block#if:. Calls @self if @obj is false-ish.
    """

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