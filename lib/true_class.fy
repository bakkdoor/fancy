class TrueClass {
  "TrueClass. The class of the singleton @true value."

  def TrueClass new {
    # always return true singleton object when trying to create a new
    # TrueClass instance
    true
  }

  def if_true: block {
    block call
  }

  def if_true: then_block else: else_block {
    then_block call
  }

  def true? {
    "Returns @true."
    true
  }

  def to_s {
    "Returns @true as a @String@."
    "true"
  }

  def to_a {
    "Returns an empty @Array@."
    []
  }

  def not {
    "Returns @false."
    false
  }
}
