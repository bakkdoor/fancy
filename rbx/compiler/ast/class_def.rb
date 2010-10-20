module Fancy
  module AST

    class ClassDef < Rubinius::AST::Class
      Nodes[:class_def] = self

      def initialize(line, name, parent, body)
        if name.kind_of?(Fancy::AST::Identifier)
          name = name.name
        end
        super(line, name, parent, body)
      end

    end

  end
end
