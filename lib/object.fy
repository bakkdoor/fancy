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

  def if_true: block {
    "Calls the @block if @true? returns @true"
    block call: [self]
  }

  def if_true: then_block else: else_block {
    "Calls the @then_block if @true? returns @true - otherwise @else_block is called"
    then_block call: [self]
  }

  def if_false: block {
    "Calls the @block if @false? returns @true@"
    nil
  }

  def if_false: then_block else: else_block {
    "Calls the @then_block if @false? returns @true - otherwise @else_block is called"
    else_block call
  }

  def if_nil: block {
    "Calls the @block if @nil? returns @true@"
    nil
  }

  def if_nil: then_block else: else_block {
    "Calls the @then_block if @nil? returns @true - otherwise @else_block is called"
    else_block call
  }

  def nil? {
    "Returns @false."
    false
  }

  def false? {
    "Returns @false."
    false
  }

  def true? {
    "Returns @false."
    false
  }

  def to_a {
    """
    @return @Array@ representation of @self.
    """
    [self]
  }

  def to_i {
    """
    @return @Fixnum@ representation of @self.
    """
    0
  }

  def to_enum {
    """
    @return @FancyEnumerator@ for @self using 'each: for iteration.
    """

    FancyEnumerator new: self
  }

  def to_enum: iterator {
    """
    @iterator Message to use for iteration on @self.
    @return @FancyEnumerator@ for @self using @iterator for iteration.
    """

    FancyEnumerator new: self with: iterator
  }

  def and: other {
    """
    @other Object or @Block@ (for short-circuit evaluation) to compare @self to.
    @return @other if both @self and @other are true-ish, @self otherwise.

    Boolean conjunction.
    If @self and @other are both true-ish (non-nil, non-false), returns @other.
    If @other is a @Block@, calls it and returns its return value.
    """

    if_true: {
      { other = other call } if: (other is_a?: Block)
      return other
    }
    return self
  }

  def or: other {
    """
    @other Object or @Block@ (for short-circuit evaluation) to compare @self to.
    @return @self if @self is true-ish, @other otherwise.

    Boolean disjunction.
    If @self is true-ish (non-nil, non-false) returns @self.
    Otherwise returns @other (if @other is a @Block@, calls it first and returns its return value)
    """
    if_true: {
      return self
    } else: {
      { other = other call } if: (other is_a?: Block)
      return other
    }
  }

  alias_method: ':&& for: 'and:
  alias_method: ':|| for: 'or:

  def if: cond then: block {
    """
    Same as:
        cond if_true: block
    """
    cond if_true: block
  }

  def if: cond then: then_block else: else_block {
    """
    Same as:
        cond if_true: then_block else: else_block
    """
    cond if_true: then_block else: else_block
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

  def do: body_block while: cond_block {
    """
    @body_block @Block@ to be called at least once and as long as @cond_block yields a true-ish value.
    @cond_block Condition @Block@ used to determine if @body_block@ should be called again.
    """

    body_block call: [nil]
    cond_block while_do: body_block
  }

  def do: body_block until: cond_block {
    """
    @body_block @Block@ to be called at least once and as long as @cond_block yields a false-ish value.
    @cond_block Condition @Block@ used to determine if @body_block@ should be called again.
    """

    body_block call
    cond_block until_do: body_block
  }

  def unless: cond do: block {
    """
    Same as:
      cond if_true: { nil } else: block
    """

    cond if_true: { nil } else: block
  }

  def method: method_name {
    """
    @return @Method@ with @method_name defined for @self, or @nil.
    Returns the method with a given name for self, if defined.
    """

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

  def __spawn_actor__ {
    @__actor__active__ = true
    Actor spawn: {
      __actor__loop__
    }
  }

  def __actor__loop__ {
    while: { @__actor__active__ } do: {
      sender = nil
      try {
        type, msg, sender = Actor receive
        msg, params = msg
        match type {
          case 'async ->
            self send_message: msg with_params: params
          case 'future ->
            val = self send_message: msg with_params: params
            sender completed: val
        }
      } catch Exception => e {
        if: sender then: {
          sender failed: e
        }
      }
    }
  }

  def __actor__die!__ {
    @__actor__active__ = false
    @__actor__ = nil
  }

  def __actor__ {
    @__actor__ = @__actor__ || { __spawn_actor__ }
    @__actor__
  }

  protected: [ '__spawn_actor__, '__actor__loop__, '__actor__die!__, '__actor__ ]

  def die! {
    """
    Tells an object to let its actor to die (quit running).
    """
    __actor__die!__
  }

  def actor {
    """
    Returns the Object's actor.
    If none exists at this moment, a new one will be created
    and starts running in the background.
    """
    __actor__
  }

  def send_future: message_name with_params: params ([]) {
    FutureSend new: __actor__ receiver: self message: message_name with_params: params
  }

  def send_async: message_name with_params: params ([]) {
    __actor__ ! ('async, (message_name, params), nil)
  }
}