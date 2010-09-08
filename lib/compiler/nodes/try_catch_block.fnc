def class AST {
  def class ExceptHandler : Node {
    self read_write_slots: ['class, 'var, 'body];

    def ExceptHandler class: c var: v body: b {
      eh = ExceptHandler new;
      eh class: c;
      eh var: v;
      eh body: b;
      eh
    }

    def ExceptHandler from_sexp: sexp {
      class = sexp second to_ast;
      var = sexp third to_ast;
      body = sexp fourth to_ast;
      ExceptHandler class: class var: var body: body
    }

    def to_ruby: out indent: ilvl {
      out print: $ " " * ilvl ++ "rescue ";
      @class to_ruby: out;
      out print: " => ";
      @var to_ruby: out;
      out newline;
      @body to_ruby: out indent: (ilvl + 2)
    }
  }

  def class TryCatchBlock : Node {
    self read_write_slots: ['body, 'handlers, 'final];

    def TryCatchBlock body: b handlers: h final: f {
      tcb = TryCatchBlock new;
      tcb body: b;
      tcb handlers: h;
      tcb final: f
    }

    def TryCatchBlock from_sexp: sexp {
      b = sexp second second to_ast;
      h = sexp third rest map: 'to_ast;
      f = nil;
      sexp fourth if_do: |final| {
        f = final second to_ast
      };
      TryCatchBlock body: b handlers: h final: f
    }

    def to_ruby: out indent: ilvl {
      out println: $ (" " * ilvl) ++ "begin";
      @body to_ruby: out indent: (ilvl + 2);
      out newline;
      @handlers each: |h| {
        h to_ruby: out indent: ilvl;
        out newline
      };
      @final if_do: {
        out println: $ " " * ilvl ++ "ensure";
        @final to_ruby: out indent: (ilvl + 2);
        out newline
      };
      out println: $ " " * ilvl ++ "end"
    }
  }
}
