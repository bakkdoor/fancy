class NilClass {
  "NilClass. The class of the singleton @nil value."

  def NilClass new {
    # always return nil singleton object when trying to create a new
    # NilClass instance
    nil
  }

  def if_true: block {
    "Returns @nil."
    nil
  }

  def if_true: then_block else: else_block {
    "Calls @else_block."
    else_block call
  }

  def true? {
    "Returns @false."
    false
  }

  def nil? {
    "Returns @true."
    true
  }

  def to_s {
    "Returns an empty @String@."
    ""
  }

  def to_a {
    "Returns an empty @Array@."
    []
  }

  def not {
    "Returns @true."
    true
  }

  def inspect {
    "Returns @nil as a @String@."
    "nil"
  }
}
