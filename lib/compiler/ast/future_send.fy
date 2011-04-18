class Fancy AST {
  class FutureSend : Node {
    def initialize: @line message_send: @message_send {
    }

    def bytecode: g {
      pos(g)

      body = ExpressionList new: @line list: [@message_send]
      block = BlockLiteral new: @line args: (BlockArgs new: @line) body: body

      future_send = MessageSend new: @line \
                                message: (Identifier from: "new:" line: @line) \
                                to: (Identifier from: "Future" line: @line) \
                                args: (MessageArgs new: @line args: [block])

      future_send bytecode: g
    }
  }
}