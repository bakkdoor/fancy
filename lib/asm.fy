# asm.fy
# This file loads Rubinius bytecode versions of some core methods for
# improved performance.

class Rubinius Generator {
  forwards_unary_ruby_methods
  alias_ruby_setters

  class Label {
    forwards_unary_ruby_methods
  }
}

require: "asm/array"
require: "asm/integer"
