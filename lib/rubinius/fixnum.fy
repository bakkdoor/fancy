def class Fixnum {
  # prepend a : to fancy version of ruby methods.
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+
  ruby_alias: '*
  ruby_alias: '/
  ruby_alias: '<
  ruby_alias: '>
  ruby_alias: '<=
  ruby_alias: '>=
  ruby_alias: '===
  ruby_alias: 'chr

  def times: block {
    times(&block)
  }

  def modulo: other {
    modulo(other)
  }

  # use a : so we dont overwrite ruby's % operator
  alias_method: ":%" for: "modulo:"

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
      i = i - 1
    }
    arr
  }

  def upto: num do_each: block {
    upto(num, &block)
  }

  def downto: num do_each: block {
    downto(num, &block)
  }
}
