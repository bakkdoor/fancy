class Object {
  """
  Root class of Fancy's class hierarchy.
  All classes inherit from Object.
  """

  def ++ other {
    """
    @other Other object to concatenate its @String value with.
    @return @String concatenation of @String values of @self and @other.

    Returns the @String concatenation of @self and @other.
    Calls to_s on @self and @other and concatenates the results to a new @String.
    """
    to_s + (other to_s)
  }

  def loop: block {
    "Infinitely calls the block (loops)."
    block loop
  }

  def println {
    "Same as Console println: self. Prints the object on STDOUT, followed by a newline."
    Console println: to_s
  }

  def print {
    "Same as Console print: self. Prints the object on STDOUT."
    Console print: to_s
  }

  def != other {
    "Indicates, if two objects are unequal."
    self == other not
  }

  def if_false: block {
    "Calls the block."
    nil
  }

  def if_nil: block {
    "Returns nil."
    nil
  }

  def nil? {
    "Returns nil."
    nil
  }

  def false? {
    "Returns nil."
    nil
  }

  def true? {
    "Returns nil."
    nil
  }

  def if_do: block {
    "If the object is non-nil, it calls the given block with itself as argument."

    match self {
      case nil -> nil
      case false -> nil
      case _ -> block call: [self]
    }
  }

  def if_do: then_block else: else_block {
    """If the object is non-nil, it calls the given then_block with itself as argument.
       Otherwise it calls the given else_block."""

    match self {
      case nil -> else_block call: [self]
      case false -> else_block call: [self]
      case _ -> then_block call: [self]
    }
  }

  def or_take: other {
    "Returns self if it's non-nil, otherwise returns the given object."

    if: nil? then: {
      other
    } else: {
      self
    }
  }

  def to_num {
    0
  }

  def to_a {
    [self]
  }

  def to_i {
    0
  }

  def to_enum {
    FancyEnumerator new: self
  }

  def to_enum: iterator {
    FancyEnumerator new: self with: iterator
  }

  def || other {
    "Returns @ self if self is true-ish, otherwise returns @other"
    self if_do: {
      return self
    } else: {
      return other
    }
  }

  def && other {
    "Same as Object#and:"
    and: other
  }

  def if: cond then: block {
    """
    Same as:
        cond if_do: block
    """
    cond if_do: block
  }

  def if: cond then: then_block else: else_block {
    """
    Same as:
        cond if_do: then_block else: else_block
    """
    cond if_do: then_block else: else_block
  }

  def while: cond_block do: body_block {
    """
    Same as:
      cond_block while_do: body_block
    """

    cond_block while_do: body_block
  }

  def until: cond_block do: body_block {
    """
    Same as:
      cond_block until_do: body_block
    """

    cond_block until_do: body_block
  }

  def unless: cond do: block {
    """
    Same as:
      cond if_do: { nil } else: block
    """

    cond if_do: { nil } else: block
  }

  def method: method_name {
    "Returns the method with a given name for self, if defined."

    method(message_name: method_name)
  }

  def documentation {
    "Returns the documentation string for an Object."
    Fancy Documentation for: self . to_s
  }

  def documentation: str {
    "Sets the documentation string for an Object."
    Fancy Documentation for: self is: str
  }

  def identity {
    "The identity method simply returns self."
    self
  }

  def returning: value do: block {
    """
    @value Value that gets returned at the end.
    @block A @Block@ that gets called with @value before returning @value.
    @return @value

    Returns @value after calling @block with it.
    Useful for returning some object after using it, e.g.:

        # this will return [1,2]
        returning: [] do: |arr| {
          arr << 1
          arr << 2
        }
    """

    val = value
    block call: [val]
    val
  }

  def if_responds? {
    """
    @return RespondsToProxy for @self

    Returns a @RespondsToProxy@ for @self that forwards any messages
    only if @self responds to them.

    Example usage:

        # only send 'some_message: if object responds to it:
        object if_responds? some_message: some_parameter
    """

    RespondsToProxy new: self
  }

  def backtick: str {
    """
    This is the default implementation for backtick: which gets called when using the backtick syntax.
    For example:
        `cat README`
    Gets translated to the following message send:
        self backtick: \"cat README\"
    Which allows for custom implementations of the backtick: method, if needed.
    This default implementation works the same way as in Ruby, Perl or Bash.
    It returns the output of running the given string on the command line as a @String@.
    """

    System pipe: str . read
  }

  def ? future {
    future value
  }

  def yield {
    Fiber yield
  }

  def yield: values {
    Fiber yield: values
  }

  def wait: seconds {
    Fiber yield: [seconds]
  }

  def next {
    "Skip to the next iteration"
    Fancy NextIteration new raise!
  }

  def next: value {
    "Return value for this iteration and skip to the next one"
    (Fancy NextIteration new: value) raise!
  }

  def break {
    "Stop iterating"
    Fancy BreakIteration new raise!
  }

  def break: value {
    "Return value from iteration"
    (Fancy BreakIteration new: value) raise!
  }
}
