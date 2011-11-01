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
    Executes a given @Block@ while self evals to @nil or @false.

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

  def while_true: block {
    """
    @block @Block@ to call while @self yields @true.

    Calls @block while calling @self yields a @true-ish value.
    """

    try {
      while_true_impl: block
    } catch Fancy BreakIteration => b {
      return b result
    } catch Fancy StopIteration => s {
      return s result
    }
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

    call if_true: |val| {
      return val
    } else: other_block
  }

  def if: obj {
    """
    @obj Condition object to determine if @self should be called.

    Calls @self if @obj is true-ish.
    """

    obj if_true: self
  }

  def unless: obj {
    """
    @obj Condition object to determine if @self should not be called.

    Opposite of Block#if:. Calls @self if @obj is false-ish.
    """

    obj if_true: { nil } else: self
  }

  def === val {
    """
    @val Other object to match @self against.
    @return Value of calling @self with @val.

    Matches a @Block against another object by calling @self with @val.
    """

    call: [val]
  }

  def Block name {
    "Block"
  }

  def [args] {
    """
    Same as Block#call:
    """

    call: args
  }

  def object {
    """
    Creates and returns a new @Object@ with slots defined dynamically in @self.
    Looks and feels similar to Javascript object literals.

    Example:
          o = {
            something: \"foo bar baz\"
            with: 42
          } object

          o something # => \"foo bar baz\"
          o with      # => 42
    """

    obj = DynamicSlotObject new
    self call_with_receiver: obj
    obj = obj object
    obj metaclass read_write_slots: (obj slots)
    obj
  }

  def to_hash {
    """
    Creates and returns a new @Hash@ with keys and values defined dynamically in @self.
    Similar to @Block#object@ but returning a @Hash@ instead of an @Object@

    Example:
          o = {
            something: \"foo bar baz\"
            with: 42
          } to_hash   # => <['something => \"foo bar baz\", 'with => 42]>
    """

    h = DynamicKeyHash new
    self call_with_receiver: h
    h hash
  }
}
