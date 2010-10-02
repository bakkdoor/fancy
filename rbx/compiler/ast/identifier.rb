module Fancy
  module AST

    class Identifier < Node
      name :ident

      def initialize(line, identifier)
        super(line)
        @identifier = identifier
      end

      def name
        rubyfy(@identifier).to_sym
      end

      def rubyfy(ident)
        ident.split(":").join("__")
      end

      def bytecode(g)
        Rubinius::AST::LocalVariableAccess.new(line, name).bytecode(g)
      end
    end

  end
end
