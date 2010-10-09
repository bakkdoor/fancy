# Block = BlockEnvironment

def class BlockEnvironment {
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

  # def call: args{
  #   call: ~args
  # }
}
