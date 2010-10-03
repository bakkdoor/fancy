module Fancy
  module AST

    class ClassDef < Node
      name :class_def

      def initialize(line, name, parent, body)
        super(line)
        @name = name
        @parent = parent
        @body = body
      end

      def bytecode(g)
        pos(g)
      end
    end

  end
end
