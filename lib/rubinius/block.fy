Block = BlockEnvironment

def class Block {
  def if: obj {
    obj nil? if_false: {
      self call
    }
  }

  def unless: obj {
    obj nil? if_true: {
      self call
    }
  }
}
