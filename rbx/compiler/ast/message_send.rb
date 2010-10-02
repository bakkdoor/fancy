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
        # for now simply output self
        # Rubinius::AST::Self.new(1).bytecode(g)
        # when receiver is self we need to enable private dispatch
        @receiver.bytecode(g)
        @message_args.bytecode(g)
        pos(g)
        g.allow_private
        g.send @message_name.name.to_sym, @message_args.size, false
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
        @args.size
      end
    end

  end
end
