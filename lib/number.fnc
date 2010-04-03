def class Number {
  def squared {
    self * self
  };

  def abs {
    self < 0 if_true: {
      self * -1
    } else: {
      self
    }
  };

  def negate {
    self * -1
  }
}
