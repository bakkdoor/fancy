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
  }
}
