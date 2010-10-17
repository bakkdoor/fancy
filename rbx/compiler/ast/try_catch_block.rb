module Fancy
  module AST

    class TryCatchBlock < Node
      name :try_catch_block

      def initialize(line, body, handlers, finally)
        super(line)
        @body = body
        @handlers = handlers
        @finally = finally || Rubinius::AST::NilLiteral.new(line)
      end

      def bytecode(g)
        pos(g)

        g.push_modifiers

        outer_retry = g.new_label
        this_retry = g.new_label
        reraise = g.new_label

        # save the current exception into a stack local
        g.push_exception_state
        outer_ex = g.new_stack_local
        g.set_stack_local outer_ex
        g.pop

        # retry label for re-entering the try body
        this_retry.set!

        handler = g.new_label
        finally = g.new_label
        done = g.new_label

        g.setup_unwind handler, Rubinius::AST::RescueType

        # make a break available to use
        if current_break = g.break
          g.break = g.new_label
        end

        # use lazy label to patch up prematuraly leaving a try body
        # via retry
        if outer_retry
          g.retry = g.new_label
        end

        # also handle redo unwinding through the rescue
        if current_redo = g.redo
          g.redo = g.new_label
        end

        @body.bytecode(g)

        g.pop_unwind
        g.pop
        g.goto finally


        if current_break
          if g.break.used?
            g.break.set!
            g.pop_unwind

            # Reset the outer exception
            g.push_stack_local outer_ex
            g.restore_exception_state

            g.goto current_break
          end

          g.break = current_break
        end

        if current_redo
          if g.redo.used?
            g.redo.set!
            g.pop_unwind

            # Reset the outer exception
            g.push_stack_local outer_ex
            g.restore_exception_state

            g.goto current_redo
          end

          g.redo = current_redo
        end

        if outer_retry
          if g.retry.used?
            g.retry.set!
            g.pop_unwind

            # Reset the outer exception
            g.push_stack_local outer_ex
            g.restore_exception_state

            g.goto outer_retry
          end

          g.retry = outer_retry
        end


        # We jump here if an exception has occurred in the body
        handler.set!

        # Expose the retry label here only, not before this
        g.retry = this_retry

        # Save exception state to use in reraise
        g.push_exception_state

        raised_exc_state = g.new_stack_local
        g.set_stack_local raised_exc_state
        g.pop

        # Save the current exception, so that calling #=== can't trample
        # it.
        g.push_current_exception

        @handlers.bytecode(g, finally)

        reraise.set!
        # remove the exception so we have the state
        g.pop
        # restore the state and reraise
        g.push_stack_local raised_exc_state
        g.restore_exception_state
        g.reraise

        finally.set!
        @finally.bytecode(g)

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

        if @var
          Fancy::AST::Assignment.new(line, @var, CurrentException.new(line)).bytecode(g)
          g.pop
        end

        @body.bytecode(g)
        g.pop unless @body.empty?

        g.clear_exception
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

      def add_handler(handler)
        @handlers.push(handler)
        self
      end
    end

    class Retry < Node
      name :retry

      def initialize(line)
        super(line)
      end

      def bytecode(g)
        g.pop
        g.goto g.retry
      end
    end

  end
end
