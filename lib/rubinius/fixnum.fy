def class Fixnum {
  def times: block {
    ruby: 'times with_block: block
  }

  def modulo: other {
    modulo: ~[other]
  }

  alias_method: '% for: "modulo:"

  def upto: num {
    i = self
    arr = []
    { i <= num } while_true: {
      arr << i
      i = i + 1
    }
    arr
  }

  def downto: num {
    i = self
    arr = []
    { i >= num } while_true: {
      arr << i
      i = i + 1
    }
    arr
  }

  def upto: num do_each: block {
    ruby: 'upto args: [num] with_block: block
  }

  def downto: num do_each: block {
    ruby: 'downto args: [num] with_block: block
  }
}
