class Object {
  """
  Root class of Fancy's class hierarchy.
  All classes inherit from Object.
  """

  def loop: block {
    "Infinitely calls the block (loops)."
    { true } while_true: {
      block call
    }
  }

  def println {
    "Same as Console println: self. Prints the object on STDOUT, followed by a newline."
    Console println: $ self to_s
  }

  def print {
    "Same as Console print: self. Prints the object on STDOUT."
    Console print: $ self to_s
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

    if: (self nil?) then: {
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

  def || other {
    "Same as Object#or:"
    or: other
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
}
