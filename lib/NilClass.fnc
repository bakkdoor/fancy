def class NilClass {
  def if_true: then_block else: else_block {
    else_block call
  };

  def if_true: block {
    nil
  };

  def if_false: block {
    block call
  };

  def if_nil: block {
    block call
  };

  def nil? {
    true
  };

  def false? {
    true
  };

  def true? {
    nil
  }
}
