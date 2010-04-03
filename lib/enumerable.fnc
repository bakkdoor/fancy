package: Fancy::Collections

def trait Enumerable {
  private: {
    # private helper method
    def with_collection: block {
      coll = self type new
      block call: [coll]
      coll
    }
  }
  
  def map: block {
    with_collection: |coll| {
      self each: |x| {
        coll << $ block call: [x]
      }
    }
  }

  def select: condition {
    with_collection: |coll| {
      self each: |x| {
        { coll << x } if: $ condition call: [x]
      }
    }
  }

  def reject: condition {
    with_collection: |coll| {
      self each: |x| {
        { coll << x } unless: $ condition call: [x]
      }
    }
  }

  def take_while: condition {
    with_collection: |coll| {
      self each: |x| {
        condition call: [x] . if_true: {
          coll << x
        } else: {
          return: coll
        }
      }
    }
  }

  def drop_while: condition {
    with_collection: |coll| {
      drop = false
      self each: |x| {
        drop if_true: {
          drop = condition call: [x]
        } else: {
          coll << x
        }
      }
    }
  }

  def reduce: block with: init_val {
    val = init_val
    self each: |x| {
      val = block call: [val, x]
    }
    val
  }

  alias: <[:map => :collect, :select => :filter]>
}
