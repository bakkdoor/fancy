module Fancy
  module AST

    class Identifier < Node
      name :ident

      def initialize(line, identifier)
        super(line)
        @identifier = identifier
      end

      def name
        rubyfy(@identifier)
      end

      def rubyfy(ident)
        ident.split(":").join("_")
      end

      def bytecode(g)
        Rubinius::AST::LocalVariableAccess.new(line, name).bytecode(g)
      end
    end

  end
end
