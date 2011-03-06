class Fancy AST {
  class AsyncSend : Node {
    def initialize: @line message_send: @message_send {
    }

    def bytecode: g {
      pos(g)

      body = ExpressionList new: @line list: [@message_send]
      block = BlockLiteral new: @line args: (BlockArgs new: @line) body: body

      fiber = MessageSend new: @line \
                          message: (Identifier from: "new:" line: @line) \
                          to: (Identifier from: "Fiber" line: @line) \
                          args: (MessageArgs new: @line args: [block])

      schedule_send = MessageSend new: @line \
                                  message: (Identifier from: "add:" line: @line) \
                                  to: (Identifier from: "Scheduler" line: @line) \
                                  args: (MessageArgs new: @line args: [fiber])

      schedule_send bytecode: g
    }
  }
}