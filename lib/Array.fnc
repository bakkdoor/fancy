# package: Fancy::Collections

def class Array {
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
    @acc = init_val;
    self each: |x| {
      @acc println;
      @acc = (block call: [@acc, x])
      @acc println;
      "" println
    };
    @acc
  }
}
