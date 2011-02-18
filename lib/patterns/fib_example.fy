require: "pattern"

# Experimental fib implementation using pattern objects
# It's really ugly right now but we'll add some syntax sugar for it
# (See comment below)

def fib: n {
  n case: (((Pattern literal: 1) || (Pattern literal: 2)) ->> { n - 1 }) otherwise: {
    n case: ((Pattern wildcard) ->> { fib: (n - 2) + (fib: $ n - 1) })
  }
}

# above should be compiled from something like this:
# def fib: n {
#   match n {
#     case <1> | <2> -> n - 1
#     case <_> -> fib: (n - 2) + (fib: (n - 1))
#   }
# }

n = ARGV second to_i
fib: n . inspect println