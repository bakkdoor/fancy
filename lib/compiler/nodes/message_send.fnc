def class AST {
  def class MessageSend : Node {
    self read_write_slots: ['receiver, 'method_ident, 'args];

    def MessageSend from_sexp: sexp {
      receiver = sexp[1] to_ast;
      message_name = sexp[2] to_ast;
      args = sexp[3] map: |a| { a to_ast };
      AST::MessageSend receiver: receiver method_ident: message_name args: args
    }

    def MessageSend receiver: recv method_ident: mident args: args {
      ms = AST::MessageSend new;
      ms receiver: recv;
      ms method_ident: mident;
      ms args: args;
      ms
    }

    def to_ruby: out {
      @receiver to_ruby: out;
      out print: ".";
      @method_ident to_ruby: out;
      out print: "(";
      out print: $ @args map: |a| { a to_ruby: out } . join: ", ";
      out print: ")"
    }
  }
}
