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