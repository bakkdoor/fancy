class Fancy AST {
  class Require : Node {
    def initialize: @line file: @string {
    }

    def bytecode: g {
      pos(g)
      ms = MessageSend new: @line \
                       message: (Identifier from: "require:" line: @line)    \
                       to: (Identifier from: "Fancy::CodeLoader" line: @line) \
                       args: (MessageArgs new: @line args: [@string])
      ms bytecode: g
    }
  }
}
