class FalseClass {
  "FalseClass. The class of the singleton @false value."

  def FalseClass new {
    # always return false singleton object when trying to create a new
    # FalseClass instance
    false
  }

  def if_true: block {
    "Returns @nil."
  }

  def if_true: then_block else: else_block {
    "Calls @else_block."
    else_block call
  }

  def false? {
    "Returns @true."
    true
  }

  def to_s {
    "Returns @false as a @String@."
    "false"
  }

  def to_a {
    "Returns an empty @Array@."
    []
  }

  def not {
    """
    @return @true

    Boolean negation of @false => @true.
    """

    true
  }
}
