module Fancy
  module AST

    class MethodDef < Node

      name :method_def

      def initialize(line, method_ident, args, body)
        super(line)
        @method_ident = method_ident
        puts @method_ident.inspect
        @args = args
        @body = body
      end

      def bytecode(g)
        pos(g)
        @expressions.each do |expr|
          expr.bytecode(g)
        end
      end

    end

  end
end
