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
  }
}
