class Tuple {
  """
  Tuples are fixed-size containers providing index-based access to its
  elements.
  """

  include: FancyEnumerable

  def [idx] {
    """
    Forwards to @Tuple@#at:.
    """

    at: idx
  }

  def first {
    """
    @return The first element in @self.
    """

    at: 0
  }

  def second {
    """
    @return The second element in @self.
    """

    at: 1
  }

  def third {
    """
    @return The third element in @self.
    """

    at: 2
  }

  def fourth {
    """
    @return The fourth element in @self.
    """

    at: 3
  }

  def each: block {
    """
    @block @Block@ to be called for each element in @self.
    @return Return value of calling @block on the last item in @self.

    Calls a given @Block@ with each element in the @Tuple@.
    """

    val = nil
    size times: |i| {
      val = block call: [at: i]
    }
    val
  }

  def == other {
    """
    @other Other @Tuple@ to compare @self with.
    @return @true, if tuples are equal element-wise, @false otherwise.

    Compares two @Tuple@s with each other.
    """

    if: (other is_a?: Tuple) then: {
      if: (size == (other size)) then: {
        size times: |i| {
          unless: (self[i] == (other[i])) do: {
            return false
          }
        }
        return true
      }
    }
    return false
  }

  def inspect {
    """
    @return A @String@ representation of @self.
    """

    str = "("
    each: |v| {
      str = str ++ v
    } in_between: {
      str = str ++ ", "
    }
    str = str ++ ")"
    str
  }

  def Tuple === obj {
    """
    Matches @Tuple@ class against an object.
    If the given object is a Tuple instance, return a Tuple object.

    @obj Object to be matched against
    @return Tuple instance containing the values of @obj to be used in pattern matching.
    """

    if: (obj is_a?: Tuple) then: {
      [obj] + (obj map: 'identity)
    }
  }
}