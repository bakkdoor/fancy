def class AST {
  def class MethodDefinition : Node {
    read_slots: ['method]

    def initialize: method {
      @method = method
      @docstring = @method docstring
    }

    def MethodDefinition from_sexp: sexp {
      MethodDefinition new: (sexp second to_ast)
    }

    def to_s {
      "<MethodDefinition: method:" ++ @method ++ ">"
    }

    def to_ruby: out indent: ilvl {
      s = " " * ilvl # indent level
      out print: $ s ++ "def "

      MethodDefinition output: out method: @method indent: ilvl

      (MethodDefinition output: out docstring: @docstring for: (Identifier new: "self") method: (@method ident) indent: ilvl)
    }

    def MethodDefinition output: out method: method indent: ilvl {
      "Helper method for outputting the method header & body code."

      method ident to_ruby: out

      # output args, if any given
      method args empty? if_false: {
        out print: "("
        method args each: |arg| {
          arg to_ruby: out
        } in_between: {
          out print: ","
        }
        out print: ")"
      }

      out newline

      # output method's body
      { method body to_ruby: out indent: (ilvl + 2) } if: (method body)

      out newline
      out print: $ s ++ "end"
    }

    def MethodDefinition output: out docstring: docstring for: object method: method_ident indent: ilvl {
      "Helper method for outputting the docstring setter code."

      # docstring, if given
      docstring if_do: {
        out newline
        out print: $ " " * ilvl
        object to_ruby: out
        out print: ".method('"
        method_ident to_ruby: out
        out print: "').docstring = "
        out print: $ docstring inspect
        out newline
      }
    }
  }
}
