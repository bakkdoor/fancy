module Fancy
  module AST

    class ClassDef < Rubinius::AST::Class
      Nodes[:class_def] = self

      def initialize(line, name, parent, body)
        super(line, name.name, parent, body)
      end
    end

  end
end
