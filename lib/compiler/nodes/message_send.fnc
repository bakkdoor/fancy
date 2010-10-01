def class AST {
  def class MessageSend : Node {
    """
    Represents message sends in Fancy.
    """

    read_slots: ['receiver, 'method_ident, 'args]

    def initialize: recv method_ident: mident args: args {
      @receiver = recv
      @method_ident = mident
      @args = args
    }

    def MessageSend from_sexp: sexp {
      receiver = sexp[1] to_ast
      message_name = sexp[2] to_ast
      args = sexp[3] map: |a| { a to_ast }
      MessageSend new: receiver method_ident: message_name args: args
    }

    def to_ruby_sexp: out {
      out print: "[:message_send, "
      @receiver to_ruby_sexp: out
      out print: ", "
      @method_ident to_ruby_sexp: out
      out print: ", "
      out print: "[:message_args, "
      @args each: |a| {
        a to_ruby_sexp: out
      } in_between: { out print: ", " }
      out print: "]"

      out print: "]"
    }
  }
}
