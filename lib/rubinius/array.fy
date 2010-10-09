def class Array {

  def Array new: size with: default {
    "Create a new Array with a given size and default-value."

    Array new: ~[size, default] # direct call to Array.new(size, default) in ruby
  }

  def append: arr {
    "Appends another Array onto this one."

    arr is_a? Array . if_true: {
      arr each: |other| {
        self << other
      }
      tmp # TODO: does the method return this ?
    } else: {
      nil
    }
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
    ruby: 'each with_block: block
  }

  def remove_at: obj {
    """Removes an element at a given index.
     If given an Array of indices, removes all the elements with these indices.
     Returns the deleted object if an index was given, the last deleted object for an Array given."""

    obj is_a?: Number . if_true: {
      delete_at: obj # call to ruby-Array#delete_at
    } else: {
      obj is_a?: Array . if_true: {
        obj each: |idx| {
          delete_at: obj # call to ruby-Array#delete_at
        }
      }
    }
  }

  def at: idx {
    ruby: '[] args: [idx]
  }

  def first {
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
    ruby: 'each_with_index with_block: block
  }

  def indices_of: item {
    "Returns an Array of all indices of this item. Empty Array if item does not occur."

    tmp = []
    each_with_index: |obj, idx| {
      item == obj if_true: {
        tmp << idx
      }
    }
    tmp
  }

  def from: from to: to {
    "Returns sub-array starting at from: and going to to:"

    ruby: '[] args: [from, to + 1]
  }

  def last: count {
    "Returns new Array with last n elements specified."

    ruby: 'last args: [count]
  }

  def any?: block {
    "Takes condition-block and returns true if any element meets it."

    ruby: 'any? with_block: block
  }

  def all?: block {
    "Takes condition-block and returns true if all elements meet it."
    ruby: 'all? with_block: block
  }

  def select_with_index: block {
    "Same as select, just gets also called with an additional argument for each element's index value."

    tmp = []
    ruby: 'each_with_index with_block: |obj idx| {
      block call: [obj, idx] . if_true: {
        tmp << obj
      }
    }
    tmp
  }

  def reject!: block {
    ruby: 'reject! with_block: block
  }

}
