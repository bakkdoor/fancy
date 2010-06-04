# package: Fancy::Collections

def class Enumerable {
  "Mixin-Class with useful methods for collections that implement an 'each:' method.";

  def include?: item {
    "Indicates, if a collection includes a given element.";

    self any?: |x| { item == x }
  }

  def any?: condition {
    "Indicates, if any element meets the condition.";

    found = nil;
    self each: |x| {
      (condition call: x) if_true: {
        found = true
      }
    };
    found
  }

  def all?: condition {
    "Indicates, if all elements meet the condition.";

    all = true;
    self each: |x| {
      (condition call: x) if_false: {
        all = nil
      }
    };
    all
  }

  def find: item {
    "Returns nil, if the given object isn't found, or the object, if it is found.";

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
    "Similar to 'find:' but takes a block that is called for each element to find it.";

    found = nil;
    self each: |x| {
      block call: x . if_do: |item| {
        found = item
      }
    };
    found
  }

  def map: block {
    "Returns a new Array with the results of calling a given block for every element";

    coll = [];
    self each: |x| {
      coll << (block call: [x])
    };
    coll
  }

  def select: condition {
    "Returns a new Array with all elements that meet the given condition block.";

    coll = [];
    self each: |x| {
      { coll << x } if: $ condition call: [x]
    };
    coll
  }

  def reject: condition {
    "Returns a new Array with all elements that don't meet the given condition block.";

    coll = [];
    self each: |x| {
      { coll << x } unless: $ condition call: [x]
    };
    coll
  }
  
  def take_while: condition {
    "Returns a new Array by taking elements from the beginning as long as they meet the given condition block.";

    coll = [];
    stop = nil;
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
    "Returns a new Array by skipping elements from the beginning as long as they meet the given condition block.";

    coll = [];
    drop = nil;
    first_check = true;
    self each: |x| {
      (drop or: first_check) if_true: {
        drop = condition call: [x];
        first_check = nil
      } else: {
        coll << x
      }
    };
    coll
  }

  def reduce: block with: init_val {
    "Calculates a value based on a given block to be called on an accumulator value and an initial value.";

    acc = init_val;
    self each: |x| {
      acc = (block call: [acc, x])
    };
    acc
  }

  def uniq {
    "Returns a new Array with all unique values (double entries are skipped).";

    uniq_vals = [];
    self each: |x| {
      uniq_vals include?: x . if_false: {
        uniq_vals << x
      }
    };
    uniq_vals
  }

  def size {
    "Returns the size of an Enumerable.";

    i = 0;
    self each: |x| {
      i = i + 1
    };
    i
  }

  def empty? {
    "Indicates, if the Enumerable is empty (has no elements).";
    self size == 0
  }

  def first {
    self at: 0
  }
  
  def last {
    "Returns the last element in an Enumerable.";

    item = nil;
    self each: |x| {
      item = x
    };
    item
  }

  def compact {
    "Returns a new Array with all values removed that are nil (return true on nil?).";

    self reject: |x| { x nil? }
  }

  def superior_by: comparison_block {
    "Returns the superiour element in the Enumerable that has met the given comparison block with all other elements.";

    retval = self first;
    self each: |x| {
      (comparison_block call: [retval, x]) if_true: {
        retval = x
      }
    };
    retval
  }
  
  def max {
    "Returns the maximum value in the Enumerable (via the '<' comparison message).";
    self superior_by: :<
  }

  def min {
    "Returns the maximum value in the Enumerable (via the '>' comparison message).";
    self superior_by: :>
  }
}
