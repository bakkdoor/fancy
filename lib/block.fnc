def class Block {
  def NATIVE while_true: block {
    """Executes a given Block while self evals to true\nExample:
       i = 0
       { i < 10 } while_true: { x println x = x + 1 }"""

    self call if_true: {
      block call
      self while_true: block
    }
  }

  def while_false: block {
    """Executes a given Block while self evals to nil\nExample:
    i = 0
    { i >= 10 } while_false: { i println i = i + 1 }"""

    { self call not } while_true: block
  }

  def while_nil: block {
    "Same as Block#while_false:"

    self while_false: block
  }
}
