# Tuning the performance of Array#[]
require: "profiler"
n = 100_000
a = [1, 2]

class Array {
  def index_fy: index {
    match index {
      case Integer          -> at: index
      case Fancy Enumerable -> from: (index_fy: 0) to: (index_fy: 1)
    }
  }

  dynamic_method('index_bc:) |g| {
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

#a = [1, 2]
#(a index_impl: false . inspect) println
#System exit

"[profile] Starting index_fy: with n = #{n to_s}... " print
s = Time now
start_profile!
n times: |x| {
  y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0 # 5 calls
  y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0 # 5 calls
  y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0 # 5 calls
  y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0 # 5 calls
  y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0; y = a index_fy: 0 # 5 calls
}
stop_profile!
"Done in #{(Time now - s) to_s}" println
Profiler show()

"[profile] Starting index_bc: with n = #{n to_s}... " print
s = Time now
start_profile!
n times: |x| {
  y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0 # 5 calls
  y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0 # 5 calls
  y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0 # 5 calls
  y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0 # 5 calls
  y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0; y = a index_bc: 0 # 5 calls
}
stop_profile!
"Done in #{(Time now - s) to_s}" println
Profiler show()
