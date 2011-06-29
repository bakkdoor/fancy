class Number {
  """
  Number is a mixin-class for all number values (integer & floats for
  now).
  """

  def upto: num {
    """
    @num @Number@ to create an @Array@ up to.
    @return @Array@ containing numbers from @self to @num.

    Returns an Array with Numbers starting at @self and going up to @num.
    Expects @num to be greater or equal to @self.
    """

    i = self
    arr = []
    while: { i <= num } do: {
      arr << i
      i = i + 1
    }
    arr
  }

  def upto: num do: block {
    """
    @num Maximum @Number@ to call @block with.
    @block A @Block@ that should be called with each @Number@ between @self and @num.
    @return @self

    Calls @block with each @Number@ between @self and @num.
    Expects @num to be greater or equal to @self.
    """
    i = self
    while: { i <= num } do: {
      block call: [i]
      i = i + 1
    }
    self
  }

  def downto: num {
    """
    @num @Number@ to create an @Array@ down to.
    @return @Array@ containing numbers from @self down to @num.

    Returns an Array with Numbers starting at @self and going down to @num.
    Expects @num to be smaller or equal to @self.
    """

    i = self
    arr = []
    while: { i >= num } do: {
      arr << i
      i = i - 1
    }
    arr
  }

  def downto: num do: block {
    """
    @num Minimum @Number@ to call @block with.
    @block A @Block@ that should be called with each @Number@ between @self and @num.
    @return @self

    Calls @block with each @Number@ between @self and @num.
    Expects @num to be smaller or equal to @self.
    """

    i = self
    while: { i >= num } do: {
      block call: [i]
      i = i - 1
    }
    self
  }

  def squared {
    """
    @return Squared value of @self.

    Returns the square of a Number.
    """

    self * self
  }

  def doubled {
    """
    @return Doubled value of @self.

    Returns the double value of a Number.
    """

    self + self
  }

  def abs {
    """
    @return Absolute (positive) value of @self.

    Returns the absolute (positive) value of a Number.
    """

    if: (self < 0) then: {
      self * -1
    } else: {
      self
    }
  }

  def negate {
    """
    @return Negated value of @self.

    Negates a Number (-1 becomes 1 and vice versa).
    """

    self * -1
  }

  def even? {
    """
    @return @true, if @self is even, @false otherwise.

    Indicates, if a Number is even.
    """

    modulo: 2 . == 0
  }

  def odd? {
    """
    @return @true, if @self is odd, @false otherwise.

    Indicates, if a Number is odd.
    """

    self even? not
  }
}