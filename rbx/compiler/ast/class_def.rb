module Fancy
  module AST

    class ClassDef < Rubinius::AST::Class
      def initialize(line, name, parent, body)
        if name.kind_of?(Fancy::AST::Identifier)
          name = name.name
        end
        super(line, name, parent, body)
        if body.expressions.first.kind_of?(Rubinius::AST::StringLiteral)
          doc = body.expressions.first
          body.expressions[0] = MessageSend.new(line, Rubinius::AST::Self.new(line),
                                                Fancy::AST::Identifier.new(line, "documentation:"),
                                                Fancy::AST::MessageArgs.new(line, doc))
        end
      end

    end

  end
end
