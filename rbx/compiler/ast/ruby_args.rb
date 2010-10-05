module Fancy
  module AST

    class RubyArgs < Node
      name :ruby_args

      def initialize(line, args)
        super(line)
        @args = args
      end

      def bytecode(g)
        @args.array.each do |a|
          a.bytecode(g)
        end
      end

      def size
        @args.array.size
      end
    end

  end
end
