module Fancy
  module AST

    class ClassDef < Rubinius::AST::Class
      def initialize(line, name, parent, body)
        if name.kind_of?(Fancy::AST::Identifier)
          name = name.name
        end
        super(line, name, parent, body)
      end

      def bytecode(g)
        docstring = body.body.shift_docstring
        super(g)
        MethodDef.set_docstring(g, docstring, @line)
      end

    end

  end
end
