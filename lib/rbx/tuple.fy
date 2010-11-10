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

  def == other {
    other is_a?: Tuple . if_true: {
      self size == (other size) if_true: {
        self size times: |i| {
          self[i] == (other[i]) . if_false: {
            return false
          }
        }
        return true
      }
    }
    return false
  }
}
