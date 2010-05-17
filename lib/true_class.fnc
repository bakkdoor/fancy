def class TrueClass {
  def TrueClass new {
    # always return true singleton object when trying to create a new
    # TrueClass instance
    true
  }
  
  def if_true: then_block else: else_block {
    then_block call
  }

  def if_true: block {
    block call
  }

  def nil? {
    nil
  }

  def false? {
    nil
  }

  def true? {
    true
  }
}
