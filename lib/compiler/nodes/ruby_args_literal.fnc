def class AST {
  def class RubyArgsLiteral : Node {
    self read_slots: ['args];
    def initialize: args {
      @args = args
    }

    def RubyArgsLiteral from_sexp: sexp {
      RubyArgsLiteral new: $ sexp second to_ast
    }

    def to_ruby: out indent: ilvl {
      out print: $ (" " * ilvl);
      arr = @args array;
      arr empty? if_false: {
        arr from: 0 to: -2 . each: |x| {
          x to_ast to_ruby: out;
          out print: ", "
        }
      };
      # last element
      arr last to_ast to_ruby: out
    }
  }
}
