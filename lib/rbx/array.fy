class Array {
  ruby_alias: '==
  ruby_alias: '<<
  ruby_alias: 'clear
  ruby_alias: 'size
  ruby_alias: 'reverse
  ruby_alias: 'reverse!
  ruby_alias: 'sort
  ruby_alias: 'pop
  ruby_alias: 'last
  ruby_alias: 'shuffle
  ruby_alias: 'inspect
  ruby_alias: 'shift

  def Array new: size with: default {
    "Creates a new Array with a given size and default-value."

    Array new(size, default)
  }

  def Array new: size {
    "Creates a new Array with a given size (default value is nil)."

    Array new: size with: nil
  }

  def append: arr {
    "Appends another Array onto this one."

    arr each: |x| {
      self << x
    }
    self
  }

  def includes?: obj {
    "Indicates, if an Array includes a given value."

    include?(obj)
  }

  def clone {
    "Clones (shallow copy) the Array."
    new = []
    each: |x| {
      new << x
    }
    new
  }

  def each: block {
    """
    @block @Block@ to be called for each element in @self.
    @return Return value of calling @block on the last item in @self.

    Calls a given @Block@ with each element in the @Array@.
    """

    try {
      val = nil
      each() |x| {
        try {
          val = block call: [x]
        } catch (Fancy NextIteration) => ex {
          val = ex return_value
        }
      }
      return val
    } catch (Fancy BreakIteration) => ex {
      ex return_value
    }
  }

  def remove_at: index {
    """
    Removes an element at a given index.
    If given an Array of indices, removes all the elements with these indices.
    Returns the deleted object if an index was given, the last deleted object for an Array given.
    """

    if: (index is_a?: Fixnum) then: {
      deleted = at: index
      delete_at(index)
      return deleted
    } else: {
      if: (index is_a?: Array) then: {
        count = 0
        deleted_values = []
        index each: |idx| {
          deleted_values << (at: (idx - count))
          delete_at(idx - count)
          count = count + 1
        }
        return deleted_values
      }
    }
    nil
  }

  def at: idx {
    """
    @idx Index for value to retrieve.
    @return Value with the given index (if available), or @nil.

    Returns the element in the @Array@ at a given index.
    """

    ruby: '[] args: [idx]
  }

  def at: idx put: obj {
    """
    @idx Index to set a value for.
    @obj Value (object) to be set at the given index.
    @return @obj

    Inserts a given object at a given index (position) in the Array.
    """

    ruby: '[]= args: [idx, obj]
  }

  def each_with_index: block {
    """
    @block @Block@ to be called with each element and its inde in the @Array@.

    Iterate over all elements in Array. Calls a given Block with each element and its index.
    """

    i = 0
    each: |x| {
      block call: [x, i]
      i = i + 1
    }
  }

  def index: item {
    """
    @item Item/Value for which the index is requested within an @Array@.
    @return Index of the value passed in within the @Array@, or @nil, if value not present.

    Returns the index of an item (or nil, if it isn't in the @Array@).
    """
    index(item)
  }

  def indices_of: item {
    """
    @item Item/Value for which a list of indices is requested within an @Array@.
    @return @Array@ of all indices for a given value within an @Array@ (possibly empty).

    Returns an Array of all indices of this item. Empty Array if item does not occur.
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
    from upto: to do_each: |i| {
      subarr << (at: i)
    }
    subarr
  }

  def last: count {
    """
    @count Number of last elements to get from an @Array@.
    @return @Array@ with up to @count size of last elements in @self.

    Returns new Array with last n elements specified.
    """
    last(count)
  }

  def any?: block {
    """
    @block Predicate @Block@ to be called for each element until it returns @true for any one of them.
    @return @true if any element in @self yields @true for @block, @false otherwise.

    Takes condition-block and returns @true if any element meets it.
    """
    any?(&block)
  }

  def all?: block {
    """
    @block Predicate @Block@ to be called for each element until it returns @false for any one of them.
    @return @true if all elements in @self yield @true for @block, @false otherwise.

    Takes condition-block and returns @true if all elements meet it.
    """
    all?(&block)
  }

  def select: block {
    """
    @block Predicate @Block@ to be used as filter.
    @return @Array@ of all the elements for which @block doesn't yield @false or @nil.

    Returns a new Array with all the elements in self that yield a
    true-ish value when called with the given Block.
    """

    tmp = []
    each: |x| {
      if: (block call: [x]) then: {
        tmp << x
      }
    }
    return tmp
  }

  def select_with_index: block {
    """
    Same as select:, just gets also called with an additional argument
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

  def reject: block {
    """
    Returns a new Array with all the elements which yield nil or false
    when called with the given Block.
    """

    reject(&block)
  }

  def reject!: block {
    "Same as Array#reject: but doing so in-place (destructive)."

    reject!(&block)
    return self
  }

  def join: join_str {
    """Joins all elements in the Array by a given String.
       E.g.: [1,2,3] join: ', ' # => '1,2,3'"""

    join(join_str)
  }

  def unshift: value {
    unshift(value)
  }
}
