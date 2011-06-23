class Set {
  """
  A simple Set data structure class.
  """

  include: FancyEnumerable

  def initialize: values {
    """
    @values @FancyEnumerable@ of values to be used as values for @self.

    Initialize a new Set with a given collection of values.
    """

    @hash = <[]>
    values each: |v| {
      @hash[v]: true
    }
  }

  def initialize {
    """
    Initialize a new empty Set.
    """

    @hash = <[]>
  }

  def values {
    """
    @return Values in self as an @Array@.
    """

    @hash keys
  }

  def size {
    """
    @return Amount of values in @self as a @Fixnum@.
    """

    @hash size
  }

  def empty? {
    """
    @return @true, if Set is emty, @false otherwise.

    Indicates, if a Set is empty.
    """

    @hash empty?
  }

  def == other {
    """
    @other @Set@ to compare @self against.
    @return @true, if self is equal to @other, @false otherwise.

    Indicates, if two Sets are equal.
    """

    if: (other is_a?: Set) then: {
      values == (other values)
    } else: {
      false
    }
  }

  def Set [values] {
    """
    @values @FancyEnumerable@ of values used for new Set.

    Initialize a new Set with a given collection of values.
    """

    Set new: values
  }

  def << value {
    """
    @value Value to be inserted into @self.
    @return @self.

    Insert a value into the Set.
    """

    @hash[value]: true
    self
  }

  def includes?: value {
    """
    @value Value to be checked for if included in @self.
    @return @true if @value in @self, @false otherwise.

    Indicates, if the Set includes a given value.
    """

    @hash keys includes?: value
  }

  def each: block {
    """
    @block @Block@ to be called with each value in @self.
    @return @self.

    Calls a given Block for each element of the Set.
    """

    @hash each_key: block
    self
  }

  def to_s {
    """
    Returns a @String@ representation of a Set.
    """

    "Set[" ++ (values join: ", ") ++ "]"
  }

  def inspect {
    """
    Returns a detailed @String@ representation of a Set.
    """

    "Set[" ++ (values map: 'inspect . join: ", " to_s) ++ "]"
  }
}
