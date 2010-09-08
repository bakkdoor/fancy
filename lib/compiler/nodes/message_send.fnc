def class AST {
  def class MessageSend : Node {
    self read_write_slots: ['receiver, 'method_ident, 'args];

    def MessageSend from_sexp: sexp {
      receiver = sexp[1] to_ast;
      message_name = sexp[2] to_ast;
      args = sexp[3] map: |a| { a to_ast };
      MessageSend receiver: receiver method_ident: message_name args: args
    }

    def MessageSend receiver: recv method_ident: mident args: args {
      ms = MessageSend new;
      ms receiver: recv;
      ms method_ident: mident;
      ms args: args;
      ms
    }

    def to_ruby: out indent: ilvl {
      @receiver to_ruby: out indent: ilvl;
      out print: ".";
      @method_ident to_ruby: out;
      out print: "(";

      # output all args seperated by a comma
      @args each: |a| {
        a to_ruby: out
      } in_between: { out print: ", " };

      out print: ")"
    }
  }
}
