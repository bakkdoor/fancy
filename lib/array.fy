class Array {
  """
  Array class.
  Arrays are dynamically resizable containers with a constant-time
  index-based access to members.
  """

  include: FancyEnumerable

  def [] index {
    """
    Given an Array of 2 Numbers, it returns the sub-array between the
    given indices.
    If given a Number, returns the element at that index.
    """

    # if given an Array, interpret it as a from:to: range subarray
    if: (index is_a?: Array) then: {
      from: (index[0]) to: (index[1])
    } else: {
      at: index
    }
  }

  def first {
    "Returns the first element in the Array."
    at: 0
  }

  def second {
    "Returns the second element in the Array"
    at: 1
  }

  def third {
    "Returns the third element in the Array"
    at: 2
  }

  def fourth {
    "Returns the fourth element in the Array"
    at: 3
  }

  def rest {
    "Returns all elements except the first one as a new Array."
    from: 1 to: -1
  }

  def =? other {
    """
    @other Other @Array@ to compare this one to.

    Compares two Arrays where order does not matter.
    """

    if: (other is_a?: Array) then: {
      if: (size != (other size)) then: {
        nil
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

  def join {
    """
    @return Elements of @Array@ joined to a @String@.

    Joins all elements with the empty @String@.
        [\"hello\", \"world\", \"!\"] join # => \"hello, world!\"
    """

    join: ""
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
    "Prints each element on a seperate line."

    each: |x| {
      x println
    }
  }

  def to_s {
    "Returns @String@ representation of @Array@."

    reduce: |x y| { x ++ y } init_val: ""
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

  def + other_arr {
    "Returns concatenation with another @Array@."

    clone append: other_arr
  }

  def indices {
    "Returns an @Array@ of all the indices of an @Array@."

    0 upto: (size - 1)
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

  def sum {
    """
    Calculates the sum of all the elements in the Enumerable
    (assuming them to be Numbers (implementing '+' & '*')).
    """

    reduce: |x y| { x + y } init_val: 0
  }

  def product {
    """Calculates the product of all the elements in the Enumerable
      (assuming them to be Numbers (implementing '+' & '*'))."""

    reduce: |x y| { x * y } init_val: 1
  }
}
