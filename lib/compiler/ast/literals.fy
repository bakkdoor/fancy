class Fancy AST {
  class NilLiteral : Rubinius AST NilLiteral {
    def initialize: line { initialize(line) }
    def bytecode: g { bytecode(g) }
  }

  class FixnumLiteral : Rubinius AST FixnumLiteral {
    def initialize: line value: value { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class NumberLiteral : Rubinius AST NumberLiteral {
    def initialize: line value: value { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class StringLiteral : Rubinius AST StringLiteral {
    def initialize: line value: value { initialize(line, StringHelper unescape_string(value)) }
    def bytecode: g { bytecode(g) }
  }

  class CurrentFile : Node {
    def initialize: @line filename: @filename { }
    def bytecode: g {
      args = MessageArgs new: line args: [StringLiteral new: @line value: @filename]
      MessageSend new: @line message: (Identifier from: "current_file:" line: @line) \
                  to: (Identifier from: "Fancy::CodeLoader" line: @line) \
                  args: args .
        bytecode: g
    }
  }

  class CurrentLine : Node {
    def initialize: @line {}
    def bytecode: g {
      FixnumLiteral new: @line value: @line . bytecode: g
    }
  }

  class Nothing : Node {
    def initialize: @line { }
    def bytecode: g { }
  }

  class StackTop : Node {
    def initialize: @line { }
    def bytecode: g { g dup() }
  }

  class StackLocal : Node {
    def initialize: @line { }
    def set: g { @local = g new_stack_local(); g set_stack_local(@local) }
    def bytecode: g { g push_stack_local(@local) }
  }

  class Self : Rubinius AST Self {
    def initialize: line { initialize(line) }
    def bytecode: g { bytecode(g) }
  }

  class SymbolLiteral : Rubinius AST SymbolLiteral {
    def initialize: line value: value { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class RegexpLiteral : Rubinius AST RegexLiteral  {
    def initialize: line value: value { initialize(line, value, 0) }
    def bytecode: g { bytecode(g) }
  }

  class ArrayLiteral : Rubinius AST ArrayLiteral {
    read_slots: ['array]
    def initialize: line array: @array {
      @array if_nil: { @array = [] }
      initialize(line, @array)
    }
    def bytecode: g { bytecode(g) }
  }

  class HashLiteral : Rubinius AST HashLiteral {
    def initialize: line entries: @key_values {
      @key_values if_nil: { @key_values = [] }
      initialize(line, @key_values)
    }
    def bytecode: g { bytecode(g) }
  }
}
