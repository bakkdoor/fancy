# package: Fancy::Collections

def class Array {
  self include: Enumerable;

  NATIVE def [] index {
    ""Given an Array of 2 Numbers, it returns the sub-array between the given indices.
      If given a Number, returns the element at that index."";

    # if given an Array, interpret it as a from:to: range substring
    index is_a?: Array . if_true: {
      self from: (index[0]) to: (index[1])
    } else: {
      self at: index
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

  def values_at: idx_arr {
    "Returns new Array with elements at given indices";

    values = [];
    idx_arr each: |idx| {
      values << (self at: idx)
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

  NATIVE def each_with_index: block {
    "Iterate over all elements in Array. Calls a given Block with each element and its index.";

    self size times: |idx| {
      block call: [self at: idx, idx]
    }
  }
  
  NATIVE def select_with_index: condition {
    "Same as select, just gets also called with an additional argument for each element's index value.";
    
    coll = [];
    self each_with_index: |x i| {
      { coll << [x, i] } if: $ condition call: [x, i]
    };
    coll
  };

  NATIVE def reject!: condition {
    "Removes all elements in place, that meet the condition.";
    
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

    self remove_at: (self indices: obj)
  }

  def remove_if: condition {
    "Removes all elements that meet the given condition block.";

    self remove_at:
      (self select_with_index: condition
         . map: :second)
  }

  def println {
    "Prints each element on a seperate line.";

    self each: |x| {
      x println
    }
  }

  def to_s {
    "Returns String representation of Array.";

    str = "";
    self reduce: |x y| { x ++ y } with: str
  }

  def * num {
    "Returns a new Array that contains the elements of self num times in a row.";

    arr = [];
    num times: {
      self each: |x| { arr << x }
    };
    arr
  }

  def + other_arr {
    "Returns concatenation with another Array.";

    self clone append: other_arr
  }
}
