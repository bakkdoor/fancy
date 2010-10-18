def class Fixnum {
  # prepend a : to fancy version of ruby methods.
  alias_method: ":==" for: "=="
  alias_method: ":-" for: "-"
  alias_method: ":+" for: "+"
  alias_method: ":*" for: "*"
  alias_method: ":/" for: "/"
  alias_method: ":<" for: "<"
  alias_method: ":>" for: ">"
  alias_method: ":<=" for: "<="
  alias_method: ":>=" for: ">="
  alias_method: ":===" for: "==="

  def times: block {
    ruby: 'times with_block: block
  }

  def modulo: other {
    modulo: ~[other]
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
