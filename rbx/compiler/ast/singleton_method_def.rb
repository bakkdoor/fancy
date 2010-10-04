module Fancy
  module AST

    class SingletonMethodDef < Rubinius::AST::DefineSingleton
      Nodes[:singleton_method_def] = self

      def initialize(line, obj_ident, method_ident, args, body)
        @line = line
        @receiver = obj_ident
        @name = method_ident.name.to_sym
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
    end

  end
end
