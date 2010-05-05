def class Block {
  def while_false: block {
    "Executes given block while self evals to nil";

    { self call not } while_true: block
  }

  def while_nil: block {
    "Same as Block#while_false:";

    self while_false: block
  }
}
