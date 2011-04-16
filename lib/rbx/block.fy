# Block = BlockEnvironment

class Block {
  ruby_alias: 'arity

  def argcount {
    """
    @return Arity of a @Block@.

    Returns the amount of arguments (arity) a Block takes.
    """

    arity()
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
    call_under(receiver, method() scope())
  }

  def call: args with_receiver: receiver {
    call_under(receiver, method() scope(), *args)
  }

  dynamic_method('while_true:) |g| {
    loop = g.new_label()
    end = g.new_label()
    g total_args=(1)

    loop set!()
    g push_self()
    g send('call, 0)
    g set_local(1)
    g gif(end)
    g push_local(0)
    g push_local(1)
    g send('call, 1)
    g pop()
    g check_interrupts()
    g goto(loop)

    end set!()
    g push_nil()
    g ret()
  }
}

class Rubinius VariableScope {
  def receiver {
    @self
  }

  def receiver: recv {
    @self = recv
  }
}