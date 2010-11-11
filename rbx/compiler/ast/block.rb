class Fancy
  class AST

    class BlockLiteral < Rubinius::AST::Iter
      def initialize(line, args, body)
        @args = args
        body = body || Rubinius::AST::NilLiteral.new(line)
        super(line, args, body)
        args.create_locals(self)

        if args.total_args == 0
          @arguments.prelude = nil
        end
        if args.total_args > 1
          @arguments.prelude = :multi
        end
        @arguments.required_args = args.required_args
      end

      def bytecode(g)
        docstring = body.shift_docstring
        super(g)
        MethodDef.set_docstring(g, docstring, line, @args.args)
      end
    end

    class BlockArgs < Node
      attr_accessor :args, :block

      def initialize(line, *args)
        super(line)
        @args = args.map{|a| a.name.to_sym}
      end

      def bytecode(g)
        if @args.size > 1
          @args.each_with_index do |a, i|
            g.shift_array
            g.set_local i
            g.pop
          end
        else
          @args.each_with_index do |a, i|
            g.set_local i
          end
        end
      end

      def total_args
        @args.size
      end

      def required_args
        total_args
      end

      def create_locals(block)
        @args.each do |a|
          block.new_local(a)
        end
      end
    end

  end
end
