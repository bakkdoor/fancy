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
        pos(g)

        g.push_modifiers
        outer_ex = g.new_stack_local
        g.set_stack_local outer_ex
        g.pop
        

        
        handler = g.new_label
        finally = g.new_label
        done = g.new_label

        g.setup_unwind handler, Rubinius::AST::RescueType

        @body.bytecode(g)

        g.pop_unwind
        g.pop
        g.goto finally

        handler.set!
        @handlers.bytecode(g, finally)

        finally.set!
        @finally.bytecode(g) if @finally

        done.set!

        g.push_stack_local outer_ex
        g.restore_exception_state
        g.pop_modifiers
      end

    end

    class ExceptHandler < Node
      name :except_handler

      def initialize(line, condition, var, body)
        super(line)
        @condition = condition
        @var = var
        @body = body
      end

      def bytecode(g, finally)

        nothing = g.new_label

        @condition.bytecode(g)
        g.push_current_exception
        g.send :===, 1
        g.gif nothing

        Fancy::AST::Assignment.new(line, @var, CurrentException.new(line)).bytecode(g)
        g.pop
        p @body
        @body.bytecode(g)
        g.pop


        g.goto finally
        nothing.set!
      end

    end

    class CurrentException < Node

      def initialize(line)
        super(line)
      end

      def bytecode(g)
        g.push_current_exception
      end

    end

    class Handlers < Node
      name :handlers

      def initialize(line, *handlers)
        super(line)
        @handlers = handlers
      end

      def bytecode(g, finally)
        @handlers.each do |handler|
          handler.bytecode(g, finally)
        end
      end
    end

  end
end
