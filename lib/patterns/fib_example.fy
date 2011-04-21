require: "pattern"

# Experimental fib implementation using pattern objects
# It's really ugly right now but we'll add some syntax sugar for it
# (See comment below)

class Number {
  def fib {
    val = self
    self case_of: ((Pattern literal: 0) || (Pattern literal: 1) ->> { val }) otherwise: {
      self case_of: (Pattern wildcard ->> { val - 2 fib + (val - 1 fib) })
    }
  }
}

# above should be compiled from something like this:
# def fib: n {
#   match n {
#     case <0> || <1> -> n
#     case <_> -> n - 2 fib + (n - 1 fib)
#   }
# }

15 times: |x| {
  "fib(#{x}) = " print
  x fib println
}
