module Fancy
  module AST

    class RubyArgs < Node
      name :ruby_args

      def initialize(line, args, block = nil)
        super(line)
        @args = args
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
