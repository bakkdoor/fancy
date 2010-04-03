def class TrueClass {
  def if_true: then_block else: else_block {
    then_block call
  };

  def if_true: block {
    block call
  };

  def if_false: block {
    nil
  };

  def if_nil: block {
    nil
  };

  def nil? {
    nil
  };

  def false? {
    nil
  };

  def true? {
    true
  }
}
