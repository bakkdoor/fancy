module Fancy
  module AST

    class SingletonMethodDef < Rubinius::AST::DefineSingleton
      def initialize(line, obj_ident, method_ident, args, body)
        @line = line
        @receiver = obj_ident
        @name = method_ident.method_name(@receiver)
        @arguments = args
        @body = SingletonMethodDefScope.new line, @name, args, body
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
        super(g, recv)
        ms = MessageSend.new(@line, StackTop.new,
                             Fancy::AST::Identifier.new(@line, "documentation:"),
                             MessageArgs.new(@line, docstring))
        ms.bytecode(g)
        g.pop
      end

      def docstring
        if @body.expressions.first.is_a? Rubinius::AST::StringLiteral
          @body.expressions.first
        else
          Rubinius::AST::NilLiteral.new(line)
        end
      end
    end

  end
end
