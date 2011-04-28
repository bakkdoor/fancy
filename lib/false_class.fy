class FalseClass {
  "FalseClass. The class of the singleton @false value."

  def FalseClass new {
    # always return false singleton object when trying to create a new
    # FalseClass instance
    false
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
