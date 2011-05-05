class Fancy
  class AST

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

        if @args.array.last.kind_of? Fancy::AST::Identifier
          if @args.array.last.identifier =~ /^\*\w/
            @splat = @args.array.pop()
            @splat = Fancy::AST::Identifier.new(@splat.line, @splat.identifier[1..-1])
          end
        end

        @block = block
      end

      def bytecode(g)
        @args.array.each do |a|
          a.bytecode(g)
        end
        if @splat
          @splat.bytecode(g)
          g.cast_array
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
