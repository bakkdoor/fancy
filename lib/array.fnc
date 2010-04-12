# package: Fancy::Collections

def class Array {
  self include: Enumerable;

  # Array equality where order matters
  # e.g. [1,2,3] == [2,1,3] should not be true
  def == other {
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

  # Array equality in a 'has the same elements, but possibly in
  # different order' way
  def === other {
    self size != (other size) if_true: {
      nil
    } else: {
      self all?: |x| { other include?: x }
    }
  }

  def index: item {
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
    item is_a?: Block . if_true: {
      self find_by: item
    } else: {
      self index: item . if_do: |idx| {
        self at: idx
      }
    }
  }

  def find_by: block {
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
    self at: 0
  }

  def second {
    self at: 1
  }

  def third {
    self at: 2
  }

  def fourth {
    self at: 3
  }

  def last {
    (self size > 0) . if_true: {
      self at: (self size - 1)
    }
  }

  def last: amount {
    (amount <= (self size)) . if_true: {
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
    values = [];
    idx_arr each: |idx| {
      self at: idx . if_do: |val| {
        values << val
      }
    };
    values
  }

  def >> other_arr {
    arr = self clone;
    arr append: other_arr
  }
}
