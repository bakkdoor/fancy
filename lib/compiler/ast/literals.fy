class Fancy AST {
  class NilLiteral : Rubinius ToolSet Runtime AST NilLiteral {
    def initialize: line {
      initialize(line)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class FixnumLiteral : Rubinius ToolSet Runtime AST FixnumLiteral {
    def initialize: line value: value {
      initialize(line, value)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class NumberLiteral : Rubinius ToolSet Runtime AST NumberLiteral {
    def initialize: line value: value {
      initialize(line, value)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class StringLiteral : Rubinius ToolSet Runtime AST StringLiteral {
    def initialize: line value: value {
      initialize(line, StringHelper unescape_string(value))
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class CurrentFile : Node {
    def initialize: @line filename: @filename {
      @string = StringLiteral new: @line value: $ File absolute_path: @filename
    }
    def bytecode: g {
      pos(g)
      @string bytecode: g
    }
  }

  class CurrentDir : Node {
    def initialize: @line filename: @filename {
      dir = File dirname: @filename
      @string = StringLiteral new: @line value: $ File absolute_path: dir
    }
    def bytecode: g {
      pos(g)
      @string bytecode: g
    }
  }

  class CurrentLine : Node {
    def initialize: @line {
      @line_number = FixnumLiteral new: @line value: @line
    }
    def bytecode: g {
      pos(g)
      @line_number bytecode: g
    }
  }

  class Nothing : Node {
    def initialize: @line
    def bytecode: g { pos(g) }
  }

  class StackTop : Node {
    def initialize: @line
    def bytecode: g {
      pos(g)
      g dup()
    }
  }

  class StackLocal : Node {
    def initialize: @line
    def set: g {
      @local = g new_stack_local(); g set_stack_local(@local)
    }
    def bytecode: g {
      pos(g)
      g push_stack_local(@local)
    }
  }

  class Self : Rubinius ToolSet Runtime AST Self {
    def initialize: line {
      initialize(line)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
    def method_name: receiver ruby_send: ruby_send {
      if: ruby_send then: {
        'self
       } else: {
         ':self
       }
    }
  }

  class SymbolLiteral : Rubinius ToolSet Runtime AST SymbolLiteral {
    read_slot: 'value
    def initialize: line value: value {
     initialize(line, value)
    }
    def string {
      value
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class RegexpLiteral : Rubinius ToolSet Runtime AST RegexLiteral  {
    def initialize: line value: value {
      initialize(line, value, 0)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class ArrayLiteral : Rubinius ToolSet Runtime AST ArrayLiteral {
    read_slot: 'array
    def initialize: line array: @array {
      @array if_nil: { @array = [] }
      initialize(line, @array)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class HashLiteral : Rubinius ToolSet Runtime AST HashLiteral {
    def initialize: line entries: @key_values {
      @key_values if_nil: { @key_values = [] }
      initialize(line, @key_values)
    }
    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }
}
