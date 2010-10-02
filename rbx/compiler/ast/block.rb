module Fancy
  module AST

    class BlockLiteral < Rubinius::AST::Iter
      Nodes[:block_lit] = self
      def initialize(line, args, body)
        body = body || Rubinius::AST::NilLiteral.new(line)
        super(line, args, body)
        args.create_locals(self)
      end
    end

    class BlockArg
      attr_accessor :name
      def initialize(name)
        @name = name
      end
    end

    class BlockArgs < Node
      name :block_args
      attr_accessor :args, :block
      def initialize(line, *args)
        super(line)
        @args = args.map{|a| BlockArg.new(a.name.to_sym)}
      end

      def bytecode(g)
        @args.each_with_index do |a, i|
          g.set_local i
        end
      end

      def create_locals(block)
        @args.each do |a|
          block.new_local(a.name)
        end
      end
    end

  end
end
