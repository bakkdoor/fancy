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
    def initialize: @array line: line { initialize(line, @array) }
    def bytecode: g { bytecode(g) }
  }

  class TupleLiteral : Node {
    def initialize: @elements line: @line { super }

    def bytecode: g {
      ary = ArrayLiteral new: [FixnumLiteral new: (@elements size) line: @line] \
                        line: @line

      ms = MessageSend new:  (Identifier from: "new" line: @line)             \
                       to:   (Identifier from: "Rubinius::Tuple" line: @line) \
                       args: (RubyArgs new: [ary] line: @line)
                       line: @line

      ms bytecode: g

      @elements each_with_index() |e i| {
        g dup()

        ary = [FixnumLiteral new: i line: @line, e]

        ms = MessageSend new:  (Identifier from: "at:put:" line: @line) \
                         to:   (Nothing new)                            \
                         args: (MessageArgs new: ary line: @line)       \
                         line: @line

        ms bytecode: g
        g pop()
      }
    }
  }

}
