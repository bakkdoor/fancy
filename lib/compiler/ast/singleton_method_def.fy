class Fancy AST {
  class SingletonMethodDef : Rubinius AST DefineSingleton {
    def initialize: @line name: @name args: @arguments body: @body access: @access owner: @receiver {
      name = @name method_name: @receiver
      @body = SingletonMethodDefScope new: @line name: name args: @arguments body: @body
    }

    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class SingletonMethodDefScope : Rubinius AST DefineSingletonScope {
    def initialize: @line name: @name args: @arguments body: @body {
      { @body = ExpressionList new: @line } unless: @body
      if: (@body empty?) then: {
        @body unshift_expression: $ NilLiteral new: @line
      }
    }

    define_method("bytecode") |g, recv| {
      bytecode: g receiver: recv
    }

    def bytecode: g receiver: receiver {
      pos(g)
      docstring = @body docstring
      sup = Rubinius AST DefineSingletonScope instance_method('bytecode)
      sup bind(self) call(g, receiver)
      MethodDef set: g docstring: docstring line: @line argnames: $ @arguments names()
    }
  }
}
