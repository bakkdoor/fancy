module Fancy
  module AST

    class MessageSend < Node

      name :message_send

      def initialize(receiver, message_name, message_args)
        @receiver = receiver
        @message_name = message_name
        @message_args = message_args
      end


      def bytecode(g)
        raise "IMPLEMENT ME !"
      end

    end

    class MessageArgs < Node
      name :message_args

      def initialize(*args)
        @args = args
      end
    end

  end
end
