class Range {
  """
  Class of Range values. Are created by using Range literal syntax in Fancy.

  Example:
      (10..100) # Range from 10 to 100
      # the following code does the same as above:
      Range new: 10 to: 100
  """

  include: FancyEnumerable

  def to_s {
    """
    Same as Range#inspect
    """

    inspect
  }

  def inspect {
    """
    @return @String@ representation of @self.
    """

    "(" ++ @start ++ ".." ++ @end ++ ")"
  }
}