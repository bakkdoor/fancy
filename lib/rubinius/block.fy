# Block = BlockEnvironment

class Block {
  def if: obj {
    obj nil? if_false: {
      obj false? if_false: {
        self call
      }
    }
  }

  def unless: obj {
    obj true? if_false: {
      self call
    }
  }

  def argcount {
    arity()
  }

  # def call: args{
  #   call(*args)
  # }

  def documentation {
    Fancy Documentation for: self
  }

  def documentation: doc {
    Fancy Documentation for: self is: doc
  }
}
