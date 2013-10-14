class Fancy
  class AST

    class TupleLiteral < Node
      attr_accessor :elements
      def initialize(line, *elements)
        super(line)
        @elements = elements
      end

      def bytecode(g)
        ms = MessageSend.new(@line,
                             Identifier.new(@line, "Rubinius::Tuple"),
                             Identifier.new(@line, "new"),
                             MessageArgs.new(@line,
                                             RubyArgs.new(@line,
                                                          ArrayLiteral.new(@line, Rubinius::ToolSet::Runtime::AST::FixnumLiteral.new(@line, @elements.size)))))
        ms.bytecode(g)
        @elements.each_with_index do |e, i|
          g.dup
          MessageSend.new(@line,
                          Nothing.new,
                          Identifier.new(@line, "at:put:"),
                          MessageArgs.new(@line,
                                          Rubinius::ToolSet::Runtime::AST::FixnumLiteral.new(@line, i),
                                          e)).bytecode(g)
          g.pop
        end
      end
    end

  end
end
