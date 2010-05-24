def class TrueClass {
  def TrueClass new {
    # always return true singleton object when trying to create a new
    # TrueClass instance
    true
  }
  
  def if_true: then_block else: else_block {
    "Calls the then_block.";
    then_block call
  }

  def if_true: block {
    "Calls the block.";
    block call
  }

  def nil? {
    "Returns nil.";
    nil
  }

  def false? {
    "Returns nil.";
    nil
  }

  def true? {
    "Returns true.";
    true
  }
}
