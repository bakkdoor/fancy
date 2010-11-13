class TupleLiteral : Node {
  def initialize: @line entries: @elements { }

  def bytecode: g {
    ary = ArrayLiteral new: @line array: [FixnumLiteral new: @line value: (@elements size)]

    ms = MessageSend new:     @line                                            \
                     message: (Identifier from: "new" line: @line)             \
                     to:      (Identifier from: "Rubinius::Tuple" line: @line) \
                     args:    (RubyArgs new: [ary] line: @line)

    ms bytecode: g

    @elements each_with_index() |e i| {
      g dup()

      ary = [FixnumLiteral new: @line value: i, e]

      ms = MessageSend new:  @line                                       \
                       message: (Identifier from: "at:put:" line: @line) \
                       to:   (Nothing new: @line)                        \
                       args: (MessageArgs new: @line args: ary)

      ms bytecode: g
      g pop()
    }
  }
}
