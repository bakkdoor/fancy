Tuple = Rubinius Tuple
class Tuple {
  """
  Tuples are fixed-size containers providing index-based access to its
  elements.
  """

  include: FancyEnumerable

  ruby_alias: 'size

  def initialize: size {
    """
    @size Size of the @Tuple@ (amount of values to hold).

    Initializes a new @Tuple@ with a given amount of element slots.
    E.g. if @size is @2, creates a 2-Tuple.
    """

    initialize(size)
  }

  def each: block {
    self size times: |i| {
      block call: [self at: i]
    }
  }

  def [] idx {
    """
    Forwards to @Tuple#at:@.
    """

    at: idx
  }

  def at: idx {
    """
    @idx Index for the element to get.
    @return Element at the given index within the @Tuple@ or @nil.

    Returns an element at a given indes.
    Possibly throws an @Rubinius::ObjectBoundsExceededError@.
    """

    at(idx)
  }

  def at: idx put: val {
    """
    @idx Index of element to set.
    @val Value to set at given index.

    Sets a value for a given index within a @Tuple@.
    """
    put(idx, val)
  }

  def == other {
    """
    @other Other @Tuple@ to compare @self with.
    @return @true, if tuples are equal element-wise, @false otherwise.

    Compares two @Tuple@s with each other.
    """

    if: (other is_a?: Tuple) then: {
      if: (self size == (other size)) then: {
        self size times: |i| {
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
    str = "("
    self each: |v| {
      str = str ++ v
    } in_between: {
      str = str ++ ", "
    }
    str = str ++ ")"
    str
  }

}
