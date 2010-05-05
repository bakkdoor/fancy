def class Number {
  def fib {
    self == 0 if_true: {
      0
    } else: {
      self == 1 if_true: {
        1
      } else: {
        self - 1 fib + (self - 2 fib)
      }
    }
  }
};

15 times: |x| {
  x fib println
}
