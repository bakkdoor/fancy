Tuple = Rubinius Tuple
class Tuple {
  forwards_unary_ruby_methods

  def initialize: size {
    """
    @size Size of the @Tuple@ (amount of values to hold).

    Initializes a new @Tuple@ with a given amount of element slots.
    E.g. if @size is @2, creates a 2-Tuple.
    """

    initialize(size)
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
}
