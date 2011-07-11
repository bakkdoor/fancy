class FalseClass {
  """
  FalseClass. The class of the singleton @false value.
  """

  def FalseClass new {
    # always return false singleton object when trying to create a new
    # FalseClass instance
    false
  }

  def if_true: block {
    "Returns @nil."
    nil
  }

  def if_true: then_block else: else_block {
    "Calls @else_block."
    else_block call
  }

  def if_false: block {
    block call: [self]
  }

  def if_false: then_block else: else_block {
    then_block call: [self]
  }

  def false? {
    "Returns @true."
    true
  }

  def to_s {
    "Returns @false as a @String@."
    "false"
  }

  alias_method: 'inspect for: 'to_s

  def not {
    """
    @return @true

    Boolean negation of @false => @true.
    """

    true
  }
}

false documentation: """
  @false is the singleton boolean false value (only instance of @FalseClass@).
  FalseClass##new yields @false.
  """
