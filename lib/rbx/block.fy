# Block = BlockEnvironment

class Block {
  def if: obj {
    "Calls itself if the given object is true-ish."

    obj nil? if_false: {
      obj false? if_false: {
        self call
      }
    }
  }

  def unless: obj {
    "Opposite of Block#if:. Calls itself if the given object is false-ish."

    if: ({ obj nil? } || { obj false? }) then: {
      self call
    }
  }

  def argcount {
    "Returns the amount of arguments (arity) a Block takes."

    arity()
  }
}
