class Fancy AST {

  class MethodDef : Rubinius AST Define {
    def initialize: @line name: @name args: @arguments body: @body access: @access {
      @method_name = @name method_name: nil
      # self generate_ivar_assignment # TODO
    }

    def bytecode: g {
      g push_self()
      g send(@access, 0)
      g pop()

      # TODO: constructors and method_missing

      # TODO: docstring
      bytecode(g)
    }
  }

  class MethodArgs : Rubinius AST FormalArguments {
    def initialize: @array line: @line {
      initialize(@line, @array map() |a| { a to_sym() }, nil, nil)
    }
  }
}
