module Fancy
  module AST

    class Super < Node
      def initialize(line)
        super(line)
      end
    end

    class SuperSend < Node
      def initialize(line, method_name, args)
        super(line)
        @method_name = method_name.name.to_sym
        @args = args
      end

      def bytecode(g)
        pos(g)
        @args.bytecode(g)
        g.send_super @method_name, @args.size
      end
    end

  end
end
