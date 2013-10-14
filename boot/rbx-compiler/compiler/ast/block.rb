class Fancy
  class AST

    class BlockLiteral < Rubinius::ToolSet::Runtime::AST::Iter
      def initialize(line, args, body, partial = false)
        @args = args
        body = body || Rubinius::ToolSet::Runtime::AST::NilLiteral.new(line)

        if body.empty?
          body.unshift_expression Rubinius::ToolSet::Runtime::AST::NilLiteral.new(line)
        end

        super(line, args, body)
        args.create_locals(self)

        if args.total_args == 0
          @arguments.prelude = nil
        end
        if args.total_args > 1
          @arguments.prelude = :multi
        end
        @arguments.required_args = args.required_args

        @partial = partial

        if @partial
          @body = ExpressionList.new @line, *@body.expressions.map{ |e| convert_to_implicit_arg_send(e) }
        end
      end

      def convert_to_implicit_arg_send(expr)
        # see self-hosted version in lib/compiler/block.fy
        # this is just a port of it so we can use partial blocks
        # in fancy's stdlib

        new_receiver = Identifier.new(@line, @args.args.first.to_s)
        case expr
          when Identifier
          expr = MessageSend.new(@line, new_receiver, expr, MessageArgs.new(@line))
          when MessageSend
          case expr.receiver
            when Self
            expr.receiver = new_receiver
            when Identifier
            expr.receiver = MessageSend.new(@line, new_receiver, expr.receiver, MessageArgs.new(@line))
            when MessageSend
            expr.receiver = convert_to_implicit_arg_send(expr.receiver)
          end
        end
        expr
      end

      def bytecode(g)
        #docstring = body.shift_docstring
        super(g)
        #MethodDef.set_docstring(g, docstring, line, @args.args)
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
