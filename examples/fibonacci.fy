# fibonacci.fy
# Example of fibonacci numbers

class Fixnum {
  def fib {
    if: (self == 0) then: {
      0
    } else: {
      if: (self == 1) then: {
        1
      } else: {
        self - 1 fib + (self - 2 fib)
      }
    }
  }
}

15 times: |x| {
  x fib println
}
