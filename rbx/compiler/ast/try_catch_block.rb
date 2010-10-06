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
        # Fancy has a simpler exception handling semantics than ruby,
        # eg, ruby has an :else block we dont use
        #
        # This code is based on rbx' exceptions.rb but only took the
        # parts fancy uses. Will need to adapt it though as fancy
        # evolves.
        
        # save current modifiers and set position 
        pos(g)
        g.push_modifiers

        # Save the current exception into a stack local
        g.push_exception_state
        outer_ex_state = g.new_stack_local
        g.set_stack_local outer_ex_state
        g.pop

        # create a label for exception handling code
        exception_handler = g.new_label
        finally = g.new_label
        done = g.new_label

        # a label for retrying the body block
        # currently not used, but will be.
        #again = g.new_label
        #again.set!

        
        # install the exception handler, rescue type
        g.setup_unwind exception_handler, Rubinius::AST::RescueType

        # execute the try body
        @body.bytecode(g)

        # this will branch to the handler if anything raised
        g.pop_unwind
        # if no exception raised, execute the finally code
        g.goto finally

        # We jump here if an exception has occurred in the body
        exception_handler.set!

        @handlers.bytecode(g, finally)

        finally.set!
        @finally.bytecode(g) if @finally
        
        done.set!

        # restore previous state
        g.push_stack_local outer_ex_state
        g.restore_exception_state
        
        g.pop_modifiers
      end
    end

    class ExceptHandler < Node
      name :except_handler

      def initialize(line, condition, var, body)
        super(line)
        # currently fancy only supports one condition per catch block
        # try { ... } catch Foo => foo { ... }
        
        @condition = condition
        @var = var
        @body = body
      end

      def bytecode(g, finally)
        pos(g)

        done = g.new_label
        matched = g.new_label

        # The current exception must be on the top of the stack
        g.push_current_exception
        @condition.bytecode(g)
        g.swap
        g.send :===, 1

        # if condition === current_ex then execute body
        g.dup
        g.gif matched

        # otherwise do nothing
        g.goto done

        matched.set!

        # assign the exception to the variable
        Fancy::AST::Assignment.new(line, @var, CurrentException.new(line)).bytecode(g)

        @body.bytecode(g)

        # then just execute the finally block
        g.goto finally

        # go here if condition not matched
        done.set!
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
