require: "../number"

class Fixnum {
  include: Number

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
  ruby_alias: 'to_i
  ruby_alias: '**
  ruby_alias: '&

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

  def to_s: base {
    to_s(base)
  }
}
