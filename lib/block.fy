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
    } catch Fancy NextIteration {
      retry
    }
  }

  alias_method: 'while_do: for: 'while_true:

  def while_true: block else: alternative {
    """
    @block @Block@ to be called while @self yields @true.
    @alternative @Block@ to be called if @self never yielded @true.
    """

    if: call then: {
      block call
      while_true: block
    } else: alternative
  }

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

  def Block inspect {
    name
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

  def to_object {
    """
    Creates and returns a new @Object@ with slots defined dynamically in @self.
    Looks and feels similar to Javascript object literals.

    Example:
          o = {
            something: \"foo bar baz\"
            with: 42
          } to_object

          o something # => \"foo bar baz\"
          o with      # => 42
    """

    DynamicSlotObject new do: self . object
  }

  def to_object_deep {
    """
    Creates and returns a new @Object@ with slots defined dynamically in @self.
    Looks and feels similar to Javascript object literals.
    Nested blocks are converted to objects as well.

    Example:
          o = {
            something: \"foo bar baz\"
            with: {
              age: 42
            }
          } to_object_deep

          o something # => \"foo bar baz\"
          o with age  # => 42
    """

    to_object tap: |o| {
      o slots each: |s| {
        val = o get_slot: s
        match val {
          case Block -> o set_slot: s value: (val to_object_deep)
        }
      }
    }
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

    DynamicKeyHash new do: self . hash
  }

  def to_hash_deep {
    """
    Creates and returns a new @Hash@ with keys and values defined dynamically in @self.
    Similar to @Block#to_hash@ but converting any value that's a @Block@ to a @Hash@ as well.

    Example:
          o = {
            something: \"foo bar baz\"
            with: 42
            and: {
              another: 'field
            }
          } to_hash_deep   # => <['something => \"foo bar baz\", 'with => 42, 'and => <['another => 'field]>]>
    """

    DynamicKeyHash new: true . do: self . hash
  }

  def to_a {
    """
    Creates and returns a new @Array@ with values defined dynamically in @self.
    Similar to @Block#to_hash@ but returning an @Array@ instead of a @Hash@

    Example:
          a = {
            something: \"foo bar baz\"
            with: 42
            something; else
          } to_a   # => [['something, \"foo bar baz\"], ['with, 42], 'something, 'else]
    """

    DynamicValueArray new do: self . array
  }

  def * iterations {
    """
    @iterations @Fixnum@ of amount of iterations to run @self.

    Runs @self @iteration times.
    Same as: `iterations times: self`

    Example:
          { \"Hello, World\" println } * 2
          # => prints \"Hello, World\" 2 times
    """

    iterations times: self
  }

  def then: block {
    """
    @block @Block@ to call after @self.
    @return @Block@ that calls @self, then @block.

    Example:
          # prints \"Hello World!\"
          { \"Hello\" print } then: { \"World!\" println }
    """

    { block call: [self call] }
  }

  alias_method: 'before: for: 'then:

  def after: block {
    """
    @block @Block@ to call before @self.
    @return @Block@ that calls @self after calling @block.

    Example:
          # prints \"Hello World!\"
          { \"World!\" println } after: { \"Hello\" print }
    """

    { self call: [block call]  }
  }

  def to_block {
    """
    @return @self.
    """

    self
  }

  def call_with_errors_logged {
    """
    Calls @self while logging any errors to @*stderr*.
    """

    call_with_errors_logged_to: *stderr*
  }

  def call_with_errors_logged: args {
    """
    @args @Array@ of arguments to call @self with.

    Calls @self with @args while logging any errors to @*stderr*.
    """

    call: args with_errors_logged_to: *stderr*
  }

  def call_with_errors_logged_to: io reraise: reraise? (false) {
    """
    @io @IO@ object to log any errors to.
    @reraise? Optional boolean indicating if any raised exception should be reraised.

    Calls @self while logging any errors to @io.
    """

    try {
      self call
    } catch StandardError => e {
      io println: e
      { e raise! } if: reraise?
    }
  }

  def call: args with_errors_logged_to: io reraise: reraise? (false) {
    """
    @args @Array@ of arguments to call @self with.
    @io @IO@ object to log any errors to.
    @reraise? Optional boolean indicating if any raised exception should be reraised.

    Calls @self with @args while logging any errors to @io.
    """

    try {
      self call: args
    } catch StandardError => e {
      io println: e
      { e raise! } if: reraise?
    }
  }
}
