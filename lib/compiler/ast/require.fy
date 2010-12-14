class Fancy AST {
  class Require : Node {
    def initialize: @line file: @string {
    }

    def bytecode: g {
      Fancy AST Self new: 1 . bytecode: g
      @string bytecode: g
      pos(g)
      g allow_private()
      g send('fancy_require, 1, false)
      # ms = MessageSend new: @line \
      #                  message: (Identifier from: "require:" line: @line)    \
      #                  to: (Identifier from: "Fancy::CodeLoader" line: @line) \
      #                  args: (MessageArgs new: @line args: [@string])
      # ms bytecode: g
    }
  }
}
