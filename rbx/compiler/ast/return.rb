module Fancy
  module AST

    class Return < Rubinius::AST::Return
      Nodes[:return] = self

      def initialize(line, expr)
        super(line, expr)
      end
    end

  end
end
