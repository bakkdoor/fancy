class Fancy AST {
  class TupleLiteral : Node {
    def initialize: @line entries: @elements {
    }

    def bytecode: g {
      pos(g)
      ary = ArrayLiteral new: @line array: [FixnumLiteral new: @line value: (@elements size)]

      args = RubyArgs new: @line args: ary

      msg_ident = Identifier from: "new" line: @line
      msg_ident ruby_ident: true
      ms = MessageSend new:     @line                                            \
                       message: (msg_ident)                                      \
                       to:      (Identifier from: "Rubinius::Tuple" line: @line) \
                       args:    args

      ms bytecode: g

      @elements each_with_index() |e i| {
        g dup()
        ary = [FixnumLiteral new: @line value: i, e]

        ms = MessageSend new:  @line                                       \
                         message: (Identifier from: "[]:" line: @line) \
                         to:   (Nothing new: @line)                        \
                         args: (MessageArgs new: @line args: ary)

        ms bytecode: g
        g pop()
      }
    }
  }
}
