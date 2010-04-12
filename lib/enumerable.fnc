# package: Fancy::Collections

def class Enumerable {
  def include?: item {
    self any?: |x| { item == x }
  }

  def any?: item {
    found = nil;
    self each: |x| {
      (x == item) if_true: {
        found = true
      }
    };
    found
  }

  def all?: item {
    all = true;
    self each: |x| {
      (x == item) if_false: {
        all = false
      }
    };
    all
  }

  def find: item {
    item is_a?: Block . if_true: {
      self find_by: item
    } else: {
      found = nil;
      self each: |x| {
        (item == x) if_true: {
          found = x
        }
      };
      found
    }
  }

  def find_by: block {
    found = nil;
    self each: |x| {
      block call: x . if_do: |item| {
        found = item
      }
    };
    found
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
  }

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
  }

  def reduce: block with: init_val {
    acc = init_val;
    self each: |x| {
      acc = (block call: [acc, x])
    };
    acc
  }

  def uniq {
    uniq_vals = [];
    self each: |x| {
      uniq_vals include?: x . if_false: {
        uniq_vals << x
      }
    };
    uniq_vals
  }

  def size {
    i = 0;
    self each: |x| {
      i = i + 1
    };
    i
  }

  def last {
    item = nil;
    self each: |x| {
      item = x
    };
    item
  }
  
  # alias: <[:map => :collect, :select => :filter]>
}
