class Fancy AST {
  class FutureSend : Node {
    def initialize: @line message_send: @message_send {
    }

    def bytecode: g {
      pos(g)
      @message_send redirect_via: 'send_future:with_params: . bytecode: g
    }
  }
}