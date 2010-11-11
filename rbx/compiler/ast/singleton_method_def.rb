class Fancy
  class AST

    class SingletonMethodDef < Rubinius::AST::DefineSingleton
      def initialize(line, obj_ident, method_ident, args, body, access = :public)
        @line = line
        @receiver = obj_ident
        @name = method_ident.method_name(@receiver)
        @arguments = args
        @body = SingletonMethodDefScope.new line, @name, args, body
        @access = access
      end

      def bytecode(g)
        g.push_self
        g.send @access, 0
        g.pop
        super(g)
      end
    end

    class SingletonMethodDefScope < Rubinius::AST::DefineSingletonScope
      def initialize(line, name, args, body)
        @line = line
        @name = name
        @arguments = args
        @body = body
      end

      def bytecode(g, recv)
        docstring = @body.shift_docstring
        super(g, recv)
        MethodDef.set_docstring(g, docstring, @line, @arguments.names)
      end

    end

  end
end
