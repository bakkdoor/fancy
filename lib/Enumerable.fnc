package: Fancy.Enumerable

def trait Enumerable {
  def map: block {
    coll = []
    self each: |x| {
      coll <<: block call: [x]
    }
    coll
  }

  def select: condition {
    coll = []
    self each: |x| {
      { coll <<: x } if: (block call: [x])
    }
    coll
  }

  def reject: condition {
    coll = []
    self each: |x| {
      { coll <<: x } unless: (block call: [x])
    }
  }

  def take_while: condition {
    coll = []
    self each: |x| {
      (block call: [x]) if_true: {
        coll <<: x
      } else: {
        return: coll
      }
    }
  }

  def drop_while: condition {
    coll = self reverse
    coll = coll take_while: condition
    coll reverse
  }

  def reduce: block with: init_val {
    val = init_val
    self each: |x| {
      val = block call: [val, x]
    }
    val
  }

  alias: [:map => :collect, :select => :filter]
}
