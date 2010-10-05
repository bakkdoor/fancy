module Fancy
  module AST

    class TryCatchBlock < Node
      name :try_catch_block

      def initialize(line, body, handlers, finally)
        super(line)
        @body = body
        @handlers = handlers
        @finally = finally
      end

      def bytecode(g)
        @body.bytecode(g)

      end
    end

    class ExceptHandler < Node
      name :except_handler

      def initialize(line, class_ident, var, body)
        super(line)
        @class_name = class_ident.name.to_sym
        @var = var.name.to_sym
        @body = body
      end

      def bytecode(g)
        raise "NOT IMPLEMENTED!"
      end
    end

    class Handlers < Node
      name :handlers

      def initialize(line, handlers)
        super(line)
        @handlers = handlers
      end

      def bytecode(g)
        raise "NOT IMPLEMENTED!"
      end
    end

  end
end
