class Number {
  """
  Number is a mixin-class for all number values (integer & floats for
  now).
  """

  def upto: num {
    i = self
    arr = []
    while: { i <= num } do: {
      arr << i
      i = i + 1
    }
    arr
  }

  def upto: num do: block {
    i = self
    { i <= num } while_true: {
      block call: [i]
      i = i + 1
    }
    self
  }

  def downto: num {
    i = self
    arr = []
    while: { i >= num } do: {
      arr << i
      i = i - 1
    }
    arr
  }

  def downto: num do: block {
    i = self
    { i >= num } while_do: {
      block call: [i]
      i = i - 1
    }
    self
  }

  def squared {
    "Returns the square of a Number."

    self * self
  }

  def doubled {
    "Returns the double value of a Number."

    self + self
  }

  def abs {
    "Returns the absolute (positive) value of a Number."

    if: (self < 0) then: {
      self * -1
    } else: {
      self
    }
  }

  def negate {
    "Negates a Number (-1 becomes 1 and vice versa)."

    self * -1
  }

  def even? {
    "Indicates, if a Number is even."

    modulo: 2 . == 0
  }

  def odd? {
    "Indicates, if a Number is odd."

    self even? not
  }

  def to_num {
    self
  }
}

class FancyEnumerable {
  def sum {
    """Calculates the sum of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing '+' & '*'))."""

    reduce: |x y| { x + y } init_val: 0
  }

  def product {
    """Calculates the product of all the elements in the @Enumerable
      (assuming them to be @Number@s (implementing @+ & @*))."""

    reduce: |x y| { x * y } init_val: 1
  }
}

