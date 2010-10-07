def class AST {
  def class ExceptHandler : Node {
    read_slots: ['class, 'var, 'body]

    def initialize: c var: v body: b {
      @class = c
      @var = v
      @body = b
    }

    def ExceptHandler from_sexp: sexp {
      class = sexp second to_ast
      var = sexp third to_ast
      body = sexp fourth to_ast
      ExceptHandler new: class var: var body: body
    }

    def to_ruby_sexp: out {
      out print: "[:except_handler, "
      @class to_ruby_sexp: out
      out print: ", "
      @var if_do: {
        @var to_ruby_sexp: out
      } else: {
        out print: "nil"
      }

      out print: ", "

      @body if_do: {
        @body to_ruby_sexp: out
      } else: {
        out print: "nil"
      }
      out print: "]"
    }
  }

  def class TryCatchBlock : Node {
    read_slots: ['body, 'handlers, 'final]

    def initialize: body handlers: h final: f {
      @body = body
      @handlers = h
      @final = f
    }

    def TryCatchBlock from_sexp: sexp {
      b = sexp second second to_ast
      h = sexp third rest map: 'to_ast
      f = nil
      sexp fourth if_do: |final| {
        f = final second to_ast
      }
      TryCatchBlock new: b handlers: h final: f
    }

    def to_ruby_sexp: out {
      out print: "[:try_catch_block, "
      @body to_ruby_sexp: out
      out print: ", [:handlers, "
      @handlers each: |h| {
        h to_ruby_sexp: out
      } in_between: {
        out print: ", "
      }
      out print: "], "

      @final if_do: {
        @final to_ruby_sexp: out
      } else: {
        out print: "nil"
      }

      out print: "]"
    }
  }

  def class Retry : Node {
    def Retry from_sexp: sexp {
      Retry new
    }

    def to_ruby_sexp: out {
      out print: "[:retry]"
    }
  }
}
