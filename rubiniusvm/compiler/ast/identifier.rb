module Fancy
  module AST

    class Identifier < Node
      name :identifier

      def initialize(identifier)
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
