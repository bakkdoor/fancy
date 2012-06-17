class Array {
  """
  Array class.
  Arrays are dynamically resizable containers with a constant-time
  index-based access to members.
  """

  include: Fancy Enumerable

  def Array new: size {
    """
    @size Initial size of the @Array@ to be created (values default to @nil).

    Creates a new Array with a given @size (default value is @nil).
    """

    Array new: size with: nil
  }

  def clone {
    """
    @return A shallow copy of the @Array@.

    Clones (shallow copy) the @Array@.
    """

    new = []
    each: |x| {
      new << x
    }
    new
  }

  def append: arr {
    """
    @arr Other @Array@ to be appended to @self.
    @return @self

    Appends another @Array@ onto this one.

    Example:
          a = [1,2,3]
          a append: [3,4,5]
          a # => [1,2,3,3,4,5]
    """

    arr each: |x| {
      self << x
    }
    self
  }

  def prepend: arr {
    """
    @arr Other @Array@ to be prepended to @self.
    @return @self

    Prepends another @Array@ to this one.

    Example:
          a = [1,2,3]
          a prepend: [4,5,6]
          a # => [4,5,6,1,2,3]
    """

    arr reverse_each: |x| {
      self unshift: x
    }
    self
  }

  def [index] {
    """
    @index Index to get the value for or @Fancy::Enumerable@ of 2 indices used for a sub-array.
    @return Element(s) stored in @self at @index, possibly @nil or an empty @Array@.

    Given an @Fancy::Enumerable@ of 2 @Fixnum@s, it returns the sub-array between the given indices.
    If given a single @Fixnum@, returns the element at that index.
    """

    if: (index is_a?: Fancy Enumerable) then: {
      start, end = index
      from: start to: end
    } else: {
      at: index
    }
  }

  def rest {
    """
    @return All elements in an @Array@ after the first one.

    Returns all elements except the first one as a new @Array@.
    """
    from: 1 to: -1
  }

  def each: block {
    """
    @block @Block@ to be called for each element in @self.
    @return @self

    Calls a given @Block@ with each element in the @Array@.
    """

    try {
      size times: |i| {
        try {
          block call: [at: i]
        } catch (Fancy NextIteration) => ex {
        }
      }
      return self
    } catch (Fancy BreakIteration) => ex {
      ex result
    }
  }

  def reverse_each: block {
    """
    @block @Block@ to be called for each element (in reverse order).
    @return @self.

    Example:
          [1,2,3] reverse_each: @{print}
          # prints: 321
    """

    size - 1 downto: 0 do: |i| {
      block call: [at: i]
    }
    self
  }

  def =? other {
    """
    @other Other @Array@ to compare this one to.
    @return @true, if all elements of @other are in @self, @false otherwise.

    Compares two Arrays where order does not matter.
    """

    if: (other is_a?: Array) then: {
      if: (size != (other size)) then: {
        false
      } else: {
        all?: |x| { other includes?: x }
      }
    }
  }

  def find: item {
    """
    @item @Object@ / Element to find in the @Array@.
    @return @item if, it's found in the @Array@, otherwise @nil.

    Returns the item, if it's in the Array or nil (if not found).
    """

    if: (item is_a?: Block) then: {
      find_by: item
    } else: {
      if: (index: item) then: |idx| {
        at: idx
      }
    }
  }

  def find_by: block {
    """
    @block @Block@ to be called for each element in the @Array@.
    @return The first element, for which @block yields @true.

    Like find: but takes a block that gets called with each element to find it.
    """

    each: |x| {
      if: (block call: [x]) then: {
        return x
      }
    }
    nil
  }

  def values_at: idx_arr {
    """
    @idx_arr @Array@ of indices.
    @return @Array@ of all the items with the given indices in @idx_arr.

    Returns new @Array@ with elements at given indices.
    """

    values = []
    idx_arr each: |idx| {
      values << (at: idx)
    }
    values
  }

  def >> other_arr {
    """
    @other_arr @Array@ to be appended to @self.
    @return New @Array@ with @other_arr and @self appended.

    Returns new Array with elements of other_arr appended to these.
    """

    arr = clone
    arr append: other_arr
  }

  def select!: condition {
    """
    @condition A condition @Block@ (or something @Callable) for selecting items from @self.
    @return @self, but changed with all elements removed that don't yield @true for @condition.

    Removes all elements in place, that don't meet the condition.
    """

    reject!: |x| { condition call: [x] . not }
    return self
  }

  def reject!: block {
    """
    Same as Array#reject: but doing so in-place (destructive).
    """

    remove_if: block
    self
  }

  def compact! {
    """
    @return @self

    Removes all nil-value elements in place.
    """

    reject!: |x| { x nil? }
    return self
  }

  def remove: obj {
    """
    @obj Object to be removed within @self.
    @return @self, with all occurances of @obj removed.

    Removes all occurances of obj in the Array.
    """

    remove_at: (indices_of: obj)
  }

  def remove_if: condition {
    """
    @condition @Block@ (or @Callable) that indicates, if an element should be removed from @self.
    @return @self, with all elements removed for which @condition yields true.

    Like @Array#remove:@, but taking a condition @Block@.
    Removes all elements that meet the given condition @Block@.
    """

    remove_at: (select_with_index: |x i| { condition call: [x] } .
                map: 'second)
  }

  def println {
    """
    Prints each element on a seperate line.
    """

    each: |x| {
      x println
    }
    nil
  }

  def inspect {
    """
    @return Pretty-printed @String@ representation of @self.

    Returns a pretty-printed @String@ representation of @self.
    Example:
          [1, 'foo, \"bar\", 42] inspect # => \"[1, 'foo, \\\"bar\\\", 42]\"
    """

    str = "["
    each: |x| {
      str << (x inspect)
    } in_between: {
      str << ", "
    }
    str << "]"
  }

  def to_a {
    """
    @return @self.
    """

    self
  }

  def * num {
    """
    Returns a new @Array@ that contains the elements of self num times
    in a row.
    """

    arr = []
    num times: {
      arr append: self
    }
    arr
  }

  def + other {
    """
    @other @Fancy::Enumerable@ to be appended.
    @return Concatenation of @self with @other.

    Returns concatenation with another @Fancy::Enumerable@.

    Example:
          [1,2,3] + [3,4,5] # => [1,2,3,3,4,5]
    """

    clone append: other
  }

  def - other {
    """
    @other @Fancy::Enumerable@ to be subtracted from @self.
    @return @Array@ of elements in @self excluding all elements in @self and @other.

    Returns an @Array@ of all values in @self that are not in @other.

    Example:
          [1,2,3,4] - [2,4,5] # => [1,3]
    """

    self reject: |x| { other includes?: x }
  }

  def indices {
    """
    @return @Array@ of all indices of @self.

    Returns an @Array@ of all the indices of an @Array@.
          [1,2,3] indices # => [0,1,2]
    """

    0 upto: (size - 1)
  }

  def indices_of: item {
    """
    @item Item/Value for which a list of indices is requested within an @Array@.
    @return @Array@ of all indices for a given value within an @Array@ (possibly empty).

    Returns an Array of all indices of this item. Empty Array if item does not occur.
          [1, 'foo, 2, 'foo] indices_of: 'foo # => [1, 3]
    """

    tmp = []
    each_with_index: |obj, idx| {
      if: (item == obj) then: {
        tmp << idx
      }
    }
    tmp
  }

  def from: from to: to {
    """
    @from Start index for sub-array.
    @to End index for sub-array.

    Returns sub-array starting at from: and going to to:
    """

    if: (from < 0) then: {
      from = size + from
    }
    if: (to < 0) then: {
      to = size + to
    }
    subarr = []
    from upto: to do: |i| {
      subarr << (at: i)
    }
    subarr
  }

  def select_with_index: block {
    """
    Same as #select:, just gets also called with an additional argument
    for each element's index value.
    """

    tmp = []
    each_with_index: |obj idx| {
      if: (block call: [obj, idx]) then: {
        tmp << [obj, idx]
      }
    }
    tmp
  }

  def to_hash {
    """
    Returns a @Hash@ with each key-value pair in @self.

    Example:
          [[1,2],[3,4]] to_hash  # => <[1 => 2, 3 => 4]>
    """

    h = <[]>
    self each: |pair| {
      k,v = pair
      h[k]: v
    }
    h
  }

  def Array === object {
    """
    @object Object to match @self against.
    @return @nil, if no match, matched values (in an @Array) otherwise.

    Matches an @Array against another object.
    """

    if: (object is_a?: Array) then: {
      return [object] + object
    }
  }
}
