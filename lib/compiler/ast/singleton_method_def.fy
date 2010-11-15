class Fancy AST {
  class SingletonMethodDef : Rubinius AST DefineSingleton {

    def initialize: @line name: @name args: @arguments body: @body access: @access owner: @receiver {
      name = @name method_name: @receiver
      @body = SingletonMethodDefScope new: @line name: name args: @arguments body: @body
    }

    def bytecode: g {
      g push_self()
      g send(@access, 0)
      g pop()
      bytecode(g)
    }

  }

  class SingletonMethodDefScope : Rubinius AST DefineSingletonScope {

    def initialize: @line name: @name args: @arguments body: @body { }

    define_method("bytecode") |g, recv| {
      bytecode: g receiver: recv
    }

    def bytecode: g receiver: receiver {
      docstring = @body shift_docstring
      sup = Rubinius AST DefineSingletonScope instance_method('bytecode)
      sup bind(self) call(g, receiver)
      # TODO documentation
      #      MethodDef set_docstring: g docstring: docstring line: @line names: @arguments names()
    }
  }
}
