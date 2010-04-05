# package: Fancy::Collections

def class Array {
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
  };

  def any?: condition {
    found = false;
    i = 0;
    size = self size;
    { found not and: (i < size) } while_true: {
      found = condition call: [self at: i];
      i = i + 1
    };
    found
  };

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
  };

  def map: block {
    coll = [];
    self each: |x| {
      coll << (block call: [x])
    };
    coll
  };
  
  def select: condition {
    coll = [];
    self each: |x| {
      { coll << x } if: $ condition call: [x]
    };
    coll
  };
  
  def reject: condition {
    coll = [];
    self each: |x| {
      { coll << x } unless: $ condition call: [x]
    };
    coll
  };

  
  def take_while: condition {
    coll = [];
    stop = false;
    self each: |x| {
      stop if_false: {
        condition call: [x] . if_true: {
          coll << x
        } else: {
          stop = true
        }
      }
    };
    coll
  };

  def drop_while: condition {
    coll = [];
    drop = false;
    self each: |x| {
      drop if_true: {
        drop = condition call: [x]
      } else: {
        coll << x
      }
    };
    coll
  };

  def reduce: block with: init_val {
    acc = init_val;
    self each: |x| {
      acc = (block call: [acc, x])
    };
    acc
  };

  def first {
    self at: 0
  };

  def second {
    self at: 1
  };

  def third {
    self at: 2
  };

  def fourth {
    self at: 3
  }
}
