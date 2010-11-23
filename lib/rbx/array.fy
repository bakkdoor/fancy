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
  }

  def includes?: obj {
    "Indicates, if an Array includes a given value."

    self include?(obj)
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
    "Calls a given Block with each element in the Array."

    val = nil
    each() |x| { val = block call: [x] }
    val
  }

  def remove_at: index {
    """Removes an element at a given index.
     If given an Array of indices, removes all the elements with these indices.
     Returns the deleted object if an index was given, the last deleted object for an Array given."""

    if: (index is_a?: Fixnum) then: {
      deleted = self at: index
      delete_at(index)
      return deleted
    } else: {
      if: (index is_a?: Array) then: {
        count = 0
        deleted_values = []
        index each: |idx| {
          deleted_values << (self at: (idx - count))
          delete_at(idx - count)
          count = count + 1
        }
        return deleted_values
      }
    }
    nil
  }

  def at: idx {
    "Returns the element in the Array at a given index."

    ruby: '[] args: [idx]
  }

  def at: idx put: obj {
    "Inserts a given object at a given index (position) in the Array."

    ruby: '[]= args: [idx, obj]
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

  def each_with_index: block {
    "Iterate over all elements in Array. Calls a given Block with each element and its index."

    i = 0
    each: |x| {
      block call: [x, i]
      i = i + 1
    }
  }

  def index: item {
    "Returns the index of an item (or nil, if it isn't in the Array)."
    index(item)
  }

  def indices_of: item {
    "Returns an Array of all indices of this item. Empty Array if item does not occur."

    tmp = []
    each_with_index: |obj, idx| {
      if: (item == obj) then: {
        tmp << idx
      }
    }
    tmp
  }

  def from: from to: to {
    "Returns sub-array starting at from: and going to to:"

    if: (from < 0) then: {
      from = self size + from
    }
    if: (to < 0) then: {
      to = self size + to
    }
    subarr = []
    from upto: to do_each: |i| {
      subarr << (self at: i)
    }
    subarr
  }

  def last: count {
    "Returns new Array with last n elements specified."
    last(count)
  }

  def any?: block {
    "Takes condition-block and returns true if any element meets it."
    any?(&block)
  }

  def all?: block {
    "Takes condition-block and returns true if all elements meet it."
    all?(&block)
  }

  def select: block {
    """
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
    Same as select, just gets also called with an additional argument
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
