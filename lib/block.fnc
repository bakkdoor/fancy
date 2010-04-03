def class Block {
  def while_false: block {
    { self call not } while_true: block
  }
}
