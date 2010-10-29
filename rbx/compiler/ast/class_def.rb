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
        if docstring
          setdoc = MessageSend.new(line,
                                   Identifier.new(line, "Fancy::Documentation"),
                                   Identifier.new(line, "for:append:"),
                                   MessageArgs.new(line,
                                                   Rubinius::AST::Self.new(line),
                                                   docstring))
          # Replace first string expression to set documentation.
          body.body.expressions.unshift setdoc
        end
        super(g)
      end

    end

  end
end
