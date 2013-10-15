# Block = BlockEnvironment

class Block {
  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods

  # low level while_true: implementation
  # use direct bytecode generation for speed purposes
  # this gives us good speed in loops
  dynamic_method('while_true_impl:) |g| {
    start = g new_label()
    end = g new_label()
    g total_args=(1)

    start set!()
    g push_self()
    g send('call, 0)
    g set_local(1)
    g gif(end)
    g push_local(0)
    g push_local(1)
    g send('call, 1)
    g pop()
    g check_interrupts()
    g goto(start)

    end set!()
    g push_nil()
    g ret()
  }

  def receiver {
    """
    @return Receiver object of a @Block@.

    Returns the receiver of the @Block@ (value for @self)
    """
    @top_scope receiver
  }

  def receiver: recv {
    """
    @recv New receiver object for a @Block@.

    Sets the receiver (value for @self) of a @Block@.
    """
    @top_scope receiver: recv
  }

  def call_with_receiver: receiver {
    """
    @receiver Receiver (value of @self) when calling the @Block@.

    Calls a @Block@ with @receiver as the receiver (referenced by @self within the Block).

    Example:

          r1 = [1,2,3]
          r2 = \"hello world\"
          b = { self class }
          b call_with_receiver: r1 # => Array
          b call_with_receiver: r2 # => String
    """

    call_on_instance(receiver)
  }

  def call: args with_receiver: receiver {
    """
    @args @Array@ of arguments passed to @self for invocation.
    @receiver Receiver (value of @self) when calling the @Block@.

    Same as @call_with_receiver: but passing along arguments to the @Block@.

    Example:

          r1 = [1,2,3]
          r2 = \"hello world\"
          b = |arg| { self to_s + arg }
          b call: [\"foo\"] with_receiver: r1 # => \"123foo\"
          b call: [\"foo\"] with_receiver: r2 # => \"hello worldfoo\"
    """

    return call_on_instance(receiver, *args)
  }

  def to_proc {
    """
    @return Ruby Proc representing @self.

    Turns a @Block@ into a Ruby Proc object.
    """

    Proc new(&self)
  }
}
