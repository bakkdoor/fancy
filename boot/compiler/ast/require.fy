class Fancy AST {
  class Require : Node {
    def initialize: @line file: file {
      initialize(@line)
      @string = file
    }

    def bytecode: g {
      Fancy AST Self new: 1 . bytecode: g
      @string bytecode: g
      pos(g)
      g allow_private()
      ms = MessageSend new: @line \
                       message: (Identifier from: "require:" line: @line)    \
                       to: (Identifier from: "Fancy::CodeLoader" line: @line) \
                       args: (MessageArgs new: @line args: [@string])
      ms bytecode: g
    }
  }
}
