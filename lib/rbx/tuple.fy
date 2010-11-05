Tuple = Rubinius Tuple
class Tuple {
  ruby_alias: 'size

  def initialize: size {
    initialize(size)
  }

  def [] idx {
    at: idx
  }

  def at: idx {
    at(idx)
  }

  def at: idx put: val {
    put(idx, val)
  }
}
