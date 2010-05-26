# package: Fancy::Collections

def class Array {
  self include: Enumerable;

  def [] index {
    ""Given an Array of 2 Numbers, it returns the sub-array between the given indices.
      If given a Number, returns the element at that index."";

    # if given an Array, interpret it as a from:to: range substring
    index is_a?: Array . if_true: {
      self from: (index[0]) to: (index[1])
    } else: {
      self at: index
    }    
  }

  def == other {
    ""Compares two Arrays where order matters.
      e.g. [1,2,3] == [2,1,3] should not be true"";

    other is_a?: Array . if_true: {
      self size != (other size) if_true: {
        nil
      } else: {
        same = true;
        size = self size;
        i = 0;
        { same and: (i < size) } while_true: {
          same = self at: i == (other at: i);
          i = i + 1
        };
        same
      }
    }
  }

  def === other {
    "Compares two Arrays where order does not matter";

    other is_a?: Array . if_true: {
      self size != (other size) if_true: {
        nil
      } else: {
        self all?: |x| { other include?: x }
      }
    }
  }

  def index: item {
    "Returns the index of an item (or nil, if it isn't in the Array)";

    found_idx = nil;
    i = 0;
    size = self size;
    { found_idx not and: (i < size) } while_true: {
      item == (self at: i) if_true: {
        found_idx = i
      };
      i = i + 1
    };
    found_idx
  }

  def indices: item {
    "Returns an Array of all indexes of this item.";

    indices = [];
    self each_with_index: |x i| {
      (x == item) if_true: {
        indices << i
      }
    };
    indices
  }

  def indices {
    "Returns an Array of all indices in the Array.";

    0 upto: (self size - 1)
  }
  def find: item {
    "Returns the item, if it's in the Array or nil (if not found).";

    item is_a?: Block . if_true: {
      self find_by: item
    } else: {
      self index: item . if_do: |idx| {
        self at: idx
      }
    }
  }

  def find_by: block {
    "Like find: but takes a block that gets called with each element to find it.";

    found = nil;
    i = 0;
    size = self size;
    { found not and: (i < size) } while_true: {
      item = block call: (self at: i);
      item nil? if_false: {
        found = self at: i
      };
      i = i + 1
    };
    found
  }

  def any?: condition {
    "Takes condition-block and returns true if any element meets it.";
    
    found = false;
    i = 0;
    size = self size;
    { found not and: (i < size) } while_true: {
      found = condition call: [self at: i];
      i = i + 1
    };
    found
  }

  def all?: condition {
    "Takes condition-block and returns true if all elements meet it.";

    all_match = true;
    i = 0;
    size = self size;
    { all_match and: (i < size) } while_true: {
      all_match = condition call: [self at: i];
      i = i + 1
    };
    all_match
  };

  def from: start_idx to: end_idx {
    "Returns sub-array starting at from: and going to to:";

    arr = [];
    size = self size;
    (start_idx >= 0 and: $ start_idx <= end_idx) if_true: {
      i = start_idx;
      { i <= end_idx and: $ i < size } while_true: {
        arr << (self at: i);
        i = i + 1
      }
    };
    arr
  }

  def first {
    "Returns the first element in the Array";

    self at: 0
  }

  def second {
    "Returns the second element in the Array";

    self at: 1
  }

  def third {
    "Returns the third element in the Array";

    self at: 2
  }

  def fourth {
    "Returns the fourth element in the Array";

    self at: 3
  }

  def last {
    "Returns the last element in the Array";

    (self size > 0) if_true: {
      self at: (self size - 1)
    }
  }

  def last: amount {
    "Returns new Array with last n elements specified.";

    (amount <= (self size)) if_true: {
      start_idx = self size - amount;
      arr = [];
      start_idx upto: (self size - 1) do_each: |i| {
        arr << (self at: i)
      };
      arr
    } else: {
      []
    }
  }

  def values_at: idx_arr {
    "Returns new Array with elements at given indices";

    values = [];
    idx_arr each: |idx| {
      self at: idx . if_do: |val| {
        values << val
      }
    };
    values
  }

  def >> other_arr {
    "Returns new Array with elements of other_arr appended to these.";

    arr = self clone;
    arr append: other_arr
  }

  def join: join_str {
    ""Joins all elements in the Array by a given String.
      E.g.: [1,2,3] join: ', ' # => '1,2,3'"";

    str = "";
    max_idx = self size - 1;
    self each_with_index: |x i| {
      str = str ++ x;
      (i < max_idx) if_true: {
        str = str ++ join_str
      }
    };
    str
  }

  def join {
    "Joins all elements with the empty String.";
    # TODO: this is a hack, somehow it doesn't work with a literal string
    self join: (String new)
  }

  def select_with_index: condition {
    "Same as select, just gets also called with an additional argument for each element's index value.";
    
    coll = [];
    self each_with_index: |x i| {
      { coll << [x, i] } if: $ condition call: [x, i]
    };
    coll
  };

  def reject!: condition {
    "Removes all elements in place, that meet the condition";
    
    entries = self select_with_index: |x i| { condition call: x };
    self remove_at: $ entries map: |e| { e second };
    self
  }

  def select!: condition {
    "Removes all elements in place, that don't meet the condition";
    
    self reject!: |x| { condition call: x . not }
  }

  def compact! {
    "Removes all nil-value elements in place.";
    
    self reject!: |x| { x nil? }
  }

  def remove: obj {
    "Removes all occurances of obj in the Array.";

    self remove_with_indices: (self indices: obj)
  }

  def remove_with_indices: indices {
    "Removes all elements with the given indices (an Array of indices).";

    total = 0;
    indices each: |i| {
      self remove_at: (i - total);
      total = total + 1
    };
    self
  }

  def remove_if: condition {
    "Removes all elements that meet the given condition block.";

    self remove_with_indices:
      (self select_with_index: |x| { condition call: x }
         . map: :second)
  }

  def println {
    "Prints each element on a seperate line.";

    self each: |x| {
      x println
    }
  }

}
