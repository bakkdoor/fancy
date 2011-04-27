class FalseClass {
  "FalseClass. The class of the singleton @false value."

  def if_true: then_block else: else_block {
    "Calls @else_block."
    else_block call
  }

  def if_true: block {
    "Returns @nil."
    nil
  }

  def if_false: block {
    "Calls @block."
    block call
  }

  def if_nil: block {
    "Calls @block."
    nil
  }

  def nil? {
    "Returns @false."
    false
  }

  def false? {
    "Returns @true."
    true
  }

  def true? {
    "Returns @false."
    false
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
