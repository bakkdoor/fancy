class Fancy AST {
  class AsyncSend : Node {
    def initialize: @line message_send: @message_send

    def bytecode: g {
      pos(g)
      @message_send redirect_via: 'send_async:with_params: . bytecode: g
    }
  }
}
