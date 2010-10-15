module Fancy
  module AST

    class MessageSend < Node
      name :message_send

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
          g.allow_private

          name = @message_name.method_name(@receiver, ruby_send?)
          g.send name, @message_args.size, false
        end
      end

      def ruby_send?
        @message_args.ruby_args?
      end
    end

    class MessageArgs < Node
      name :message_args

      def initialize(line, *args)
        super(line)
        @args = args
      end

      def bytecode(g)
        @args.each do |a|
          a.bytecode(g)
        end
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
    end

  end
end
