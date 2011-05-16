# armstrong_numbers.fy
# Calculates & outputs all Armstrong Numbers between 0 and 10000.
# See http://en.wikipedia.org/wiki/Narcissistic_number for more
# information.

class Fixnum {
  def decimals {
    """Returns all decimals of a Number as an Array.
      E.g. 123 decimals # => [1,2,3]"""

    decimals = []
    tmp = self
    while: { tmp >= 10 } do: {
      decimals << (tmp modulo: 10)
      tmp = tmp div: 10
    }
    decimals << tmp
    decimals
  }

  def armstrong? {
    "Indicates, if a Number is a Armstrong Number."

    decimals = self decimals
    n_decimals = decimals size
    decimals map: |x| { x ** n_decimals } . sum == self
  }
}

# output alls Armstrong Numbers between 0 and 10000
0 upto: 10000 do: |i| {
  { i println } if: $ i armstrong?
}
