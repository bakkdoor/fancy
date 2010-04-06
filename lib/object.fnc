# package: Fancy::Lang

def class Object {
  def loop: block {
    { true } while_true: {
      block call
    }
  };

  def println {
    Console println: self
  };

  def print {
    Console print: self
  };

  def != other {
    self == other not
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
    nil
  }
}
