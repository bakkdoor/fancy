class Fancy AST {
  class NilLiteral : Rubinius AST NilLiteral {
    def initialize: @line { initialize(line) }
    def bytecode: g { bytecode(g) }
  }

  class FixnumLiteral : Rubinius AST FixnumLiteral {
    def initialize: value line: line { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class NumberLiteral : Rubinius AST NumberLiteral {
    def initialize: value line: line { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class StringLiteral : Rubinius AST StringLiteral {
    def initialize: value line: line { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class Nothing : Node {
    def initialize: line { }
    def bytecode: g { }
  }

  class StackTop : Node {
    def initialize: line { }
    def bytecode: g { g dup() }
  }

  class StackLocal : Node {
    def initialize: line { }
    def set: g { @local = g new_stack_local(); g set_stack_local(@local) }
    def bytecode: g { g push_stack_local(@local) }
  }

  class Self : Node {
    def initialize: @line { super }
    def bytecode: g { g push_self() }
  }

  class SymbolLiteral : Rubinius AST SymbolLiteral {
    def initialize: value line: line { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class ArrayLiteral : Rubinius AST ArrayLiteral {
    def initialize: @array line: line {
      @array nil? if_true: { @array = [] }
      initialize(line, @array)
    }
    def bytecode: g { bytecode(g) }
  }

  class HashLiteral : Rubinius AST HashLiteral {
    def initialize: @key_values line: line {
      @key_values nil? if_true: { @key_values = [] }
      initialize(line, @key_values)
    }
    def bytecode: g { bytecode(g) }
  }
}
