class Fancy
  class AST

    class MessageSend < Node
      def initialize(line, receiver, message_name, message_args)
        super(line)
        @receiver = receiver
        @message_name = message_name
        @message_args = message_args
      end

      def bytecode(g)
        if @receiver.is_a? Super
          SuperSend.new(@line, @message_name, @message_args).bytecode(g)
        else
          @receiver.bytecode(g)
          @message_args.bytecode(g)
          pos(g)
          g.allow_private if @receiver.is_a?(Rubinius::AST::Self)

          name = @message_name.method_name(@receiver, ruby_send?)
          if ruby_send_block?
            g.send_with_block name, @message_args.size, false
          else
            g.send name, @message_args.size, false
          end
        end
      end

      def ruby_send_block?
        @message_args.ruby_block?
      end

      def ruby_send?
        @message_args.ruby_args?
      end
    end

    class MessageArgs < Node
      attr_reader :args

      def initialize(line, *args)
        super(line)
        @args = args
      end

      def bytecode(g)
        @args.each do |a|
          a.bytecode(g)
        end
      rescue
        PP.pp(self)
        raise
      end

      def size
        if ruby_args?
          return @args.first.size
        else
          @args.size
        end
      end

      def ruby_args?
        @args.first.is_a? RubyArgs
      end

      def ruby_block?
        ruby_args? && @args.first.has_block?
      end
    end

  end
end
