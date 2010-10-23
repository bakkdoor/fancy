module Fancy
  module AST

    class RubyArgs < Node
      def initialize(line, args, block = nil)
        super(line)
        @args = args
        # If no block given and last arg is a block identifier
        if block.nil? &&
            args.array.last.kind_of?(Fancy::AST::Identifier) &&
            args.array.last.identifier =~ /^&\w/
          block = args.array.pop
          block = Fancy::AST::Identifier.new(block.line, block.identifier[1..-1])
        end
        @block = block
      end

      def bytecode(g)
        @args.array.each do |a|
          a.bytecode(g)
        end
        @block.bytecode(g) if @block
      end

      def size
        @args.array.size
      end

      def has_block?
        not @block.nil?
      end
    end

  end
end
