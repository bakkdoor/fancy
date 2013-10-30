class Integer {
  # lib/rbx/integer.fy#L4: def times: block
  overwrite_method: 'times: with_dynamic: |g| {
    while    = g new_label
    end      = g new_label
    exc      = g new_label
    exc_iter = g new_label

    g total_args: 1
    g required_args: 1

    # Locals:
    #   0: block argument
    #   1: counter (starts at 0)

    # Set up locals
    g meta_push_0
    g set_local(1)
    # Set up exception handler
    g setup_unwind(exc, Rubinius AST RescueType)

    while set!
    g push_local(1) # S: counter
    g push_self   # S: counter, self
    g meta_send_op_lt(g find_literal('<))
    g goto_if_false(end)
    # Invoke the actual block with counter as arg.
    g push_local(0) # S: block
    g push_local(1) # S: block, counter
    g meta_send_call(g find_literal('call), 1) # Faster calling for blocks (g send('call, 1))
    g pop # Don't use return of block call.
    # Increment counter
    g push_local(1)
    g meta_push_1
    g meta_send_op_plus(g find_literal('+))
    g set_local(1)
    g pop
    # Go back to start of loop.
    g check_interrupts
    g goto(while)

    # Exception handler. Checks for Fancy::BreakIteration and
    # Fancy::StopIteration.
    exc set!
    # Check if it's a BreakIteration
    g push_const('Fancy)          # S: Fancy
    g find_const('BreakIteration) # S: Fancy BreakIteration
    g push_current_exception()    # S: Fancy BreakIteration, Exception
    g kind_of
    g goto_if_true(exc_iter)
    # Check if it's a StopIteration
    g push_const('Fancy)          # S: Fancy
    g find_const('StopIteration)  # S: Fancy StopIteration
    g push_current_exception()    # S: Fancy StopIteration, Exception
    g kind_of
    g goto_if_true(exc_iter)
    # Not a break or stop, so just raise it up.
    g reraise
    # If it is a break or stop iteration, then call :result on the exception
    # and return that.
    exc_iter set!
    g push_current_exception
    g clear_exception
    g send(':result, 0)
    g ret

    # Clean end; return last counter value.
    end set!
    g pop_unwind    # Clean up unwind handler
    g push_local(1) # Return counter value
    g ret
  }
}
