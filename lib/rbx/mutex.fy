class Mutex {
  forwards_unary_ruby_methods

  def initialize {
    initialize()
  }

  def synchronize: block {
    synchronize(&block)
  }
}
