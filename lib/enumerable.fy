class FancyEnumerable {
  """
  Mixin-Class with useful methods for collections that implement an @each:@ method.
  """

  def includes?: item {
    """
    @item Item to check if it's included in @self.
    @return @true, if @item in @self, otherwise @false.

    Indicates, if a collection includes a given element.
    """
    any?: |x| { item == x }
  }

  def each: each_block in_between: between_block {
    """
    Similar to @each:@ but calls an additional @Block@ between
    calling the first @Block@ for each element in self.
    """

    between = { between = between_block }
    each: |x| {
      between call
      each_block call: [x]
    }
  }

  def any?: condition {
    """
    @condition @Block@ (or @Callable) that is used to check if any element in @self yields true for it.
    @return @true, if @condition yields @true for any element, @false otherwise.

    Indicates, if any element meets the condition.
    """

    each: |x| {
      if: (condition call: [x]) then: {
        return true
      }
    }
    nil
  }

  def all?: condition {
    """
    Similar to @FancyEnumerable#any?:@ just checking for all elements.
    Indicates, if all elements meet the condition.
    """

    each: |x| {
      unless: (condition call: [x]) do: {
        return false
      }
    }
    true
  }

  def find: item {
    """
    @item Item to be found in @self.
    @return The first element that is equal to @item or @nil, if none found.

    Returns @nil, if @item (or anything that returns @true when comparing to @item) isn't found.
    Otherwise returns that element that is equal to @item.
    """

    if: (item is_a?: Block) then: {
      find_by: item
    } else: {
      each: |x| {
        if: (item == x) then: {
          return x
        }
      }
      nil
    }
  }

  def find_by: block {
    """
    Similar to @find:@ but takes a block that is called for each element to find it.
    """

    each: |x| {
      if: (block call: [x]) then: |item| {
        return item
      }
    }
    nil
  }

  def map: block {
    """
    @block A @Block@ that gets called with each element in @self.
    @return An @Array@ containing all values of calling @block with each element in @self.

    Returns a new @Array@ with the results of calling a given block for every element.
    """

    coll = []
    each: |x| {
      coll << (block call: [x])
    }
    coll
  }

  def select: condition {
    """
    @condition A @Block@ that is used as a filter on all elements in @self.
    @return An @Array@ containing all elements in @self that yield @true when called with @condition.

    Returns a new @Array@ with all elements that meet the given condition block.
    """

    coll = []
    each: |x| {
      { coll << x } if: $ condition call: [x]
    }
    coll
  }

  def reject: condition {
    """
    Similar to @select:@ but inverse.
    Returns a new @Array@ with all elements that don't meet the given condition block.
    """

    coll = []
    each: |x| {
      { coll << x } unless: $ condition call: [x]
    }
    coll
  }

  def take_while: condition {
    """
    @condition A @Block@ that is used as a condition for filtering.
    @return An @Array@ of all elements from the beginning until @condition yields @false.

    Returns a new @Array@ by taking elements from the beginning
    as long as they meet the given condition block.
    """
    coll = []
    each: |x| {
      if: (condition call: [x]) then: {
        coll << x
      } else: {
        return coll
      }
    }
    coll
  }

  def drop_while: condition {
    """
    Similar to @take_while:@ but inverse.
    Returns a new @Array@ by skipping elements from the beginning
    as long as they meet the given condition block.
    """

    coll = []
    drop = nil
    first_check = true
    each: |x| {
      if: (drop or: first_check) then: {
        drop = condition call: [x]
        first_check = nil
        # check, if we actually have to insert his one:
        unless: drop do: {
          coll << x
        }
      } else: {
        coll << x
      }
    }
    coll
  }

  def take: amount {
    """
    @amount Amount of elements to take from @self.
    @return First @amount elements of @self in an @Array@.
    """

    i = 0
    take_while: {
      i = i + 1
      i <= amount
    }
  }

  def drop: amount {
    """
    @amount Amount of elements to skip in @self.
    @return An @Array@ of all but the first @amount elements in @self.
    """

    i = 0
    drop_while: {
      i = i + 1
      i <= amount
    }
  }

  def reduce: block init_val: init_val {
    """
    Calculates a value based on a given block to be called on an accumulator
    value and an initial value.
    """

    acc = init_val
    each: |x| {
      acc = (block call: [acc, x])
    }
    acc
  }

  def inject: val into: block {
    """
    Same as reduce:init_val: but taking the initial value as first
    and the reducing block as second parameter.
    """
    reduce: block init_val: val
  }

  def uniq {
    """
    @return @Array@ of all unique elements in @self.

    Returns a new Array with all unique values (double entries are skipped).
    """

    uniq_vals = []
    each: |x| {
      unless: (uniq_vals includes?: x) do: {
        uniq_vals << x
      }
    }
    uniq_vals
  }

  def size {
    """
    @return Amount of elements in @self.

    Returns the size of an Enumerable.
    """

    i = 0
    each: |x| {
      i = i + 1
    }
    i
  }

  def empty? {
    """
    @return @true, if size of @self is 0, @false otherwise.

    Indicates, if the Enumerable is empty (has no elements).
    """

    size == 0
  }

  def first {
    """
    @return First element in @self or @nil, if empty.
    """

    each: |x| {
      return x
    }
    nil
  }

  def last {
    """
    @return Last element in @self or @nil, if empty.

    Returns the last element in an Enumerable.
    """

    item = nil
    each: |x| {
      item = x
    }
    item
  }

  def compact {
    """
    @return @Array@ with all non-nil elements in @self.

    Returns a new @Array@ with all values removed that are @nil ( return @true on @nil? ).
    """

    reject: |x| { x nil? }
  }

  def superior_by: comparison_block {
    """
    Returns the superiour element in the @Enumerable that has met
    the given comparison block with all other elements.
    """

    retval = first
    each: |x| {
      if: (comparison_block call: [x, retval]) then: {
        retval = x
      }
    }
    retval
  }

  def max {
    """
    @return Maximum value in @self.

    Returns the maximum value in the Enumerable (via the '>' comparison message).
    """
    superior_by: '>
  }

  def min {
    """
    @return Minimum value in @self.

    Returns the minimum value in the Enumerable (via the '<' comparison message).
    """
    superior_by: '<
  }

  def partition_by: block {
    """
    @block @Block@ that gets used to decide when to partition elements in @self.
    @return @Array@ of @Array@s, partitioned by equal return values of calling @block with each element

    Example:
        0 upto: 10 . partition_by: @{< 3}  # => [[0, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10]]
    """
    last = block call: [first]
    coll = []
    tmp_coll = []
    each: |x| {
      tmp = block call: [x]
      if: (tmp != last) then: {
        coll << tmp_coll
        tmp_coll = [x]
      } else: {
        tmp_coll << x
      }
      last = tmp
    }
    coll << tmp_coll
    coll
  }
}
