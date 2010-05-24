def class NilClass {
  "NilClass. The class of the singleton nil value.";

  def NilClass new {
    # always return nil singleton object when trying to create a new
    # NilClass instance
    nil
  }
  
  def if_true: then_block else: else_block {
    "Calls else_block.";
    else_block call
  }

  def if_true: block {
    "Returns nil.";
    nil
  }

  def if_false: block {
    "Calls the block.";
    block call
  }

  def if_nil: block {
    "Calls the block.";
    block call
  }

  def nil? {
    "Returns true.";
    true
  }

  def false? {
    "Returns true.";
    true
  }

  def true? {
    "Returns nil.";
    nil
  }
}
