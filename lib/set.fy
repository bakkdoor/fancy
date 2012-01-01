class Set {
  """
  A simple Set data structure class.
  """

  include: Fancy Enumerable

  def initialize: values {
    """
    @values @Fancy::Enumerable@ of values to be used as values for @self.

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
      if: (size == (other size)) then: {
        return other all?: |x| { includes?: x }
      }
    }
    return false
  }

  def Set [values] {
    """
    @values @Fancy::Enumerable@ of values used for new Set.

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

    @hash includes?: value
  }

  def [value] {
    """
    Same as @Set#includes?:@
    """

    includes: value
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

    "Set[" ++ (values map: 'inspect . join: ", " . to_s) ++ "]"
  }

  def remove: obj {
    """
    @obj Object to be removed from @self.

    Removes a given object from a Set, if available.
    """

    @hash delete: obj
  }

  def + other {
    """
    @other Other Set to use for creating union Set.
    @return Union Set containing all values in both @self and @other.
    """

    Set[values + (other values)]
  }

  def - other {
    """
    @other Other Set to use for creating difference Set.
    @return Difference Set by removing all values from @self that are in @other.
    """

    s = Set[values]
    other values each: |v| {
      s remove: v
    }
    s
  }

  def & other {
    """
    @other Other Set to use for creating Set.
    @return Intersection Set containing only values that are in both @self and @other.
    """

    s = Set[values]
    s values each: |v| {
      { s remove: v } unless: (other includes?: v)
    }
    s
  }
}
