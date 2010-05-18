def class NilClass {
  "NilClass. The class of the singleton nil value.";

  def NilClass new {
    # always return nil singleton object when trying to create a new
    # NilClass instance
    nil
  }
  
  def if_true: then_block else: else_block {
    else_block call
  }

  def if_true: block {
    nil
  }

  def if_false: block {
    block call
  }

  def if_nil: block {
    block call
  }

  def nil? {
    true
  }

  def false? {
    true
  }

  def true? {
    nil
  }
}
