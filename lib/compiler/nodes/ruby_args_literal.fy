def class AST {
  def class RubyArgsLiteral : Node {
    read_slots: ['args]
    def initialize: args {
      @args = args
    }

    def RubyArgsLiteral from_sexp: sexp {
      RubyArgsLiteral new: $ sexp second to_ast
    }

    def to_ruby_sexp: out {
      out print: "[:ruby_args, "
      @args to_ruby_sexp: out
      out print: "]"
    }
  }
}
