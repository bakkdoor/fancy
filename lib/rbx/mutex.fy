class Mutex {
  forwards_unary_ruby_methods

  def initialize {
    initialize()
  }

  def synchronize: block {
    synchronize(&block)
  }
}

class ConditionVariable {
  forwards_unary_ruby_methods
  def initialize {
    initialize()
  }

  def wait: mutex {
    wait(mutex)
  }

  def signal {
    signal()
  }

  def broadcast {
    broadcast()
  }
}