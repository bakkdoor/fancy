def class TrueClass {
  def TrueClass new {
    # always return true singleton object when trying to create a new
    # TrueClass instance
    true
  }

  def if_true: then_block else: else_block {
    "Calls the then_block."
    then_block call
  }

  def if_true: block {
    "Calls the block."
    block call
  }

  def if_false: block {
    "Returns nil."
    nil
  }

  def nil? {
    "Returns nil."
    false
  }

  def false? {
    "Returns nil."
    false
  }

  def true? {
    "Returns true."
    true
  }

  def not {
    false
  }
}
