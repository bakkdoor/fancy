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
    end
  end
end
