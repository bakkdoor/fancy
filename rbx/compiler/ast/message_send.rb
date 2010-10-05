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
          if @receiver.kind_of?(Rubinius::AST::Self) && @message_name.identifier == "include:"
            name = :fancy_include
          else
            name = @message_name.name.to_sym
          end
          g.send name, @message_args.size, false
        end
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
        if @args.first.is_a? RubyArgs
          return @args.first.size
        else
          @args.size
        end
      end
    end

  end
end
