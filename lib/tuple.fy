ObjectBoundsExceededError = Rubinius ObjectBoundsExceededError

class Tuple {
  """
  Tuples are fixed-size containers providing index-based access to its
  elements.
  """

  include: Fancy Enumerable

  def Tuple with_values: values {
    """
    @values Values of the @Tuple@ to be created.

    Creates a new @Tuple@ with the @values passed in.

    Example:
          Tuple with_values: [1,2,3] # => (1,2,3)
    """

    t = Tuple new: $ values size
    values each_with_index: |v i| {
      t[i]: v
    }
    t
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

  def Tuple name {
    "Tuple"
  }

  def [idx] {
    """
    Forwards to @Tuple@#at:.
    """

    at: idx
  }

  def from: from to: to {
    """
    @from Start index for sub-array.
    @to End index ofr sub-array.

    Returns sub-array starting at from: and going to to:
    """

    if: (from < 0) then: {
      from = size + from
    }
    if: (to < 0) then: {
      to = size + to
    }
    subarr = []
    try {
      from upto: to do: |i| {
        subarr << (at: i)
      }
    } catch ObjectBoundsExceededError {
    }
    subarr
  }

  def each: block {
    """
    @block @Block@ to be called for each element in @self.
    @return Return value of calling @block on the last item in @self.

    Calls a given @Block@ with each element in the @Tuple@.
    """

    size times: |i| {
      block call: [at: i]
    }
    self
  }

  def reverse_each: block {
    """
    @block @Block@ to be called for each element (in reverse order).
    @return @self.

    Example:
          (1,2,3) reverse_each: @{print}
          # prints: 321
    """

    size - 1 downto: 0 do: |i| {
      block call: [at: i]
    }
    self
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
      str << (v inspect)
    } in_between: {
      str << ", "
    }
    str << ")"
    str
  }

  def to_s {
    """
    @return @String@ concatenation of elements in @self.
    """

    join
  }
}