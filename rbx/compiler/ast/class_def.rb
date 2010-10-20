module Fancy
  module AST

    class ClassDef < Rubinius::AST::Class
      Nodes[:class_def] = self

      def initialize(line, identifier, parent, body)
        super(line, identifier.name, parent, body)
      end
    end

  end
end
