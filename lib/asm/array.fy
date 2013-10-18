class Array {
  # lib/array.fy#L89: def [index]
  dynamic_method(':[]) |g| {
    check_enumerable = g new_label()
    err = g new_label()
    g total_args=(1)
    g required_args=(1)

    # Push Integer Class onto stack followed by first argument.
    g push_const('Integer)
    g push_local(0)
    # Check if that first arg. is an Integer.
    g kind_of()
    # If not an Integer then go to the Enumerable call.
    g goto_if_false(check_enumerable)
    # Call at: with Integer.
    g push_self()
    g push_local(0) # Push Integer arg back onto the stack.
    g send('at:, 1)
    g ret()

    check_enumerable set!()
    # Make sure it's an Enumerable.
    g push_const('Fancy)      # S: Fancy
    g find_const('Enumerable) # S: Fancy Enumerable
    g push_local(0)
    g kind_of()
    g goto_if_false(err) # If not go to error.
    # Extract first and second from enumerable and call from:to: with those.
    g push_self()     # S: self
    g push_local(0)   # S: self, enumerable
    g push_literal(0) # S: self, enumerable, 0
    g send('at:, 1)   # S: self, enum[0]
    # Then the second.
    g push_local(0)
    g push_literal(1)
    g send('at:, 1)   # S: self, enum[0], enum[1]
    # Now called with from:to:
    g send('from:to:, 2)
    g ret()

    err set!()
    g push_const('ArgumentError)
    g push_literal("Index must be Integer or Fancy Enumerable")
    g send('new:, 1)
    g send(':raise!, 0)
    # g pop() # Anything returned by the raise!.
    # g push_nil() # And just return nil.
    g ret()
  }
}
