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
    index is_a?: Array . if_true: {
      from: (index[0]) to: (index[1])
    } else: {
      at: index
    }
  }

  def rest {
    "Returns all elements except the first one as a new Array."
    from: 1 to: -1
  }

  def === other {
    "Compares two Arrays where order does not matter."

    other is_a?: Array . if_true: {
      self size != (other size) if_true: {
        nil
      } else: {
        all?: |x| { other include?: x }
      }
    }
  }

  def find: item {
    "Returns the item, if it's in the Array or nil (if not found)."

    item is_a?: Block . if_true: {
      find_by: item
    } else: {
      index: item . if_do: |idx| {
        at: idx
      }
    }
  }

  def find_by: block {
    "Like find: but takes a block that gets called with each element to find it."
    self each: |x| {
      block call: [x] . if_true: {
        return x
      }
    }
  }

  def values_at: idx_arr {
    "Returns new Array with elements at given indices."

    values = []
    idx_arr each: |idx| {
      values << (at: idx)
    }
    values
  }

  def >> other_arr {
    "Returns new Array with elements of other_arr appended to these."

    arr = self clone
    arr append: other_arr
  }

  def join: join_str {
    """Joins all elements in the Array by a given String.
       E.g.: [1,2,3] join: ', ' # => '1,2,3'"""

    str = ""
    max_idx = self size - 1
    each_with_index: |x i| {
      str = str ++ x
      i < max_idx if_true: {
        str = str ++ join_str
      }
    }
    str
  }

  def join {
    "Joins all elements with the empty String."

    join: ""
  }

  def select!: condition {
    "Removes all elements in place, that don't meet the condition."

    reject!: |x| { condition call: [x] . not }
    return self
  }

  def compact! {
    "Removes all nil-value elements in place."

    reject!: |x| { x nil? }
    return self
  }

  def remove: obj {
    "Removes all occurances of obj in the Array."

    remove_at: (indices_of: obj)
  }

  def remove_if: condition {
    "Removes all elements that meet the given condition block."

    remove_at: (select_with_index: condition . map: 'second)
  }

  def println {
    "Prints each element on a seperate line."

    each: |x| {
      x println
    }
  }

  def to_s {
    "Returns String representation of Array."

    reduce: |x y| { x ++ y } init_val: ""
  }

  def * num {
    """
    Returns a new Array that contains the elements of self num times
    in a row.
    """

    arr = []
    num times: {
      arr append: self
    }
    arr
  }

  def + other_arr {
    "Returns concatenation with another Array."

    self clone append: other_arr
  }

  def each: each_block in_between: between_block {
    """
    Similar to Array#each: but calls an additional Block between
    calling the first Block for each element in self.
    """

    count = 0
    size = self size
    each: |x| {
      each_block call: [x]
      count == (size - 1) if_false: {
        between_block call
      }
      count = count + 1
    }
  }

  def indices {
    "Returns an Array of all the indices of an Array."

    0 upto: (self size - 1)
  }
}
