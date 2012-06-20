class Fancy AST {
  class TryCatch : Node {
    def initialize: @line body: @body handlers: @handlers ensure: @ensure {
      if: (@body empty?) then: {
        @body unshift_expression: $ NilLiteral new: @line
      }
    }

    def bytecode: g {
      pos(g)

      g push_modifiers()

      outer_retry = g new_label()
      this_retry = g new_label()
      reraise = g new_label()

      # Save the current exception into a stack local
      g push_exception_state()
      outer_ex = g new_stack_local()
      g set_stack_local(outer_ex)
      g pop()

      # retry label for re-entring the try body
      this_retry set!()

      handler = g new_label()
      finally_ = g new_label()
      done = g new_label()

      g setup_unwind(handler, Rubinius AST RescueType)

      # make a break available to use
      current_break = g break()
      if: current_break then: { g break=(g new_label()) }

      # use lazy label to patch up prematuraly leaving a try body via retry
      if: outer_retry then: { g retry=(g new_label()) }

      # also handle redo unwinding through the rescue
      current_redo = g redo()
      if: current_redo then: { g redo=(g new_label()) }

      @body bytecode(g)

      g pop_unwind()
      g pop()
      g goto(finally_)

      if: current_break then: {
        if: (g break() used?()) then: {
          g break() set!()
          g pop_unwind()

          # Reset the outer exception
          g push_stack_local(outer_ex)
          g restore_exception_state()

          g goto(current_break)
        }
        g break=(current_break)
      }

      if: current_redo then: {
        if: (g redo() used?()) then: {
          g redo() set!()
          g pop_unwind()

          # Reset the outer exception
          g push_stack_local(outer_ex)
          g restore_exception_state()

          g goto(current_redo)
        }
        g redo=(current_redo)
      }

      if: outer_retry then: {
        if: (g retry() used?()) then: {
          g retry() set!()
          g pop_unwind()

          # Reset the outer exception
          g push_stack_local(outer_ex)
          g restore_exception_state()

          g goto(outer_retry)
        }
        g retry=(outer_retry)
      }

      # we jump here if an exception was thrown in the body
      handler set!()

      # expose the retry label here only, not before this.
      g retry=(this_retry)

      # save exception state to use in reraise
      g push_exception_state()

      raised_exc_state = g new_stack_local()
      g set_stack_local(raised_exc_state)
      g pop()

      # save the current exception so calling #=== cant trample it.
      g push_current_exception()

      @handlers each: |h| { h bytecode: g final_tag: finally_ }

      reraise set!()

      # execte the finally block before propagating the exception
      @ensure bytecode: g

      # remove the exception so we have the state
      g pop()
      # restore the state and reraise
      g push_stack_local(raised_exc_state)
      g restore_exception_state()
      g reraise()

      finally_ set!()
      @ensure bytecode: g

      done set!()

      g push_stack_local(outer_ex)
      g restore_exception_state()
      g pop_modifiers()
    }
  }

  class ExceptionHandler : Node {
    def initialize: @line condition: @condition var: @var body: @body

    def bytecode: g final_tag: final_tag {
      pos(g)
      nothing = g new_label()
      @condition bytecode: g
      g push_current_exception()
      g send('===, 1)
      g gif(nothing)

      if: @var then: {
        Assignment new: @line var: @var value: (CurrentException new: @line) .
          bytecode: g
        g pop()
      }

      @body bytecode: g
      { g pop() } unless: $ @body empty?

      g clear_exception()
      g pop()

      g goto(final_tag)
      nothing set!()
    }
  }

  class CurrentException : Node {
    def initialize: @line

    def bytecode: g {
      pos(g)
      g push_current_exception()
    }
  }

  class Retry : Node {
    def initialize: @line

    def bytecode: g {
      pos(g)
      g pop()
      g goto(g retry())
    }
  }
}
