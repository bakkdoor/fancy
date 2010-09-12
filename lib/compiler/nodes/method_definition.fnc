def class AST {
  def class MethodDefinition : Node {
    read_slots: ['method]

    def is_protected: p {
      @method is_protected: p
    }

    def is_private: p {
      @method is_private: p
    }


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

#      (MethodDefinition output: out docstring: @docstring for: (Identifier new: "self") method: (@method ident) indent: ilvl)
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
      out newline
      method is_protected if_true: {
        out print: $ s ++ "protected :"
        method ident to_ruby: out
      }
      method is_private if_true: {
        out print: $ s ++ "private :"
        method ident to_ruby: out
      }
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

  def class ProtectedMethodDefinition : Node {
    def ProtectedMethodDefinition from_sexp: sexp {
      method_def = sexp second to_ast
      method_def is_protected: true
      method_def is_private: nil
      method_def
    }
  }

  def class PrivateMethodDefinition : Node {
    def PrivateMethodDefinition from_sexp: sexp {
      method_def = sexp second to_ast
      method_def is_protected: nil
      method_def is_private: true
      method_def
    }
  }
}
