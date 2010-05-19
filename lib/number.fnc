def class Number {
  "Number class for all number values (integer & doubles for now).";

  def squared {
    "Returns the square of a Number.";

    self * self
  }

  def abs {
    "Returns the absolute (positive) value of a Number.";

    self < 0 if_true: {
      self * -1
    } else: {
      self
    }
  }

  def negate {
    "Negates a Number (-1 becomes 1 and vice versa).";

    self * -1
  }

  def even? {
    "Indicates, if a Number is even.";

    self modulo: 2 . == 0
  }

  def odd? {
    "Indicates, if a Number is odd.";

    self even? not
  }

  def upto: val {
    "Returns an Array of Numbers from self up to a given (larger) Number.";

    coll = [];
    tmp = self;
    { tmp <= val } while_true: {
      coll << tmp;
      tmp = tmp + 1
    };
    coll
  }

  def downto: val {
    "Returns an Array of Numbers from self down to a given (smaller) Number.";

    coll = [];
    tmp = self;
    { tmp >= val } while_true: {
      coll << tmp;
      tmp = tmp - 1
    };
    coll
  }

  def upto: val do_each: block {
    "Calls a given block for each value between self and a given (larger) Number.";

    tmp = self;
    { tmp <= val } while_true: {
      block call: tmp;
      tmp = tmp + 1
    }
  }

  def downto: val do_each: block {
    "Calls a given block for each value between self and a given (smaller) Number.";

    tmp = self;
    { tmp >= val } while_true: {
      block call: tmp;
      tmp = tmp - 1
    }
  }

  def ** power {
    "Calculates the given power of a Number.";

    val = 1;
    power times: {
      val = val * self
    };
    val
  }
};

def class Enumerable {
  def sum {
    "Calculates the sum of all the elements in the Array (assuming them to be Numbers).";

    self reduce: |x y| { x + y } with: 0
  }

  def product {
    "Calculates the product of all the elements in the Array (assuming them to be Numbers).";

    self reduce: |x y| { x * y } with: 1
  }
}

