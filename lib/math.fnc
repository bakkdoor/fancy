#package: Fancy::Math

def class Number {
  def even? {
    self modulo: 2 . == 0
  }

  def odd? {
    self even? not
  }

  def upto: val {
    coll = [];
    tmp = self;
    { tmp <= val } while_true: {
      coll << tmp;
      tmp = tmp + 1
    }
  }

  def downto: val {
    coll = [];
    tmp = self;
    { tmp >= val } while_true: {
      coll << tmp;
      tmp = tmp - 1
    }
  }

  def integer? {
    self is_a?: Integer
  }
  
  def real? {
    self is_a?: Real
  }

  def complex? {
    self is_a?: Complex
  }
};

def class Enumerable {
  def sum {
    self reduce: |x y| { x + y } with: 0
  }

  def product {
    self reduce: |x y| { x * y } with: 1
  }
}
