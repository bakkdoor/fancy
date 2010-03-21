package: Fancy::Lang

def class Object {
  def loop: block {
    { true } while_true: block
  }

  def print {
    Console println: self
  }
}
