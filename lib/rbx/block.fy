# Block = BlockEnvironment

class Block {
  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods

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

  # Ugh. HACK.
  # Use try/catch to deal with older and latest version of rbx (method got changed)
  def call_with_receiver: receiver {
    try {
      return call_under(receiver, method() scope())
    } catch {
      return call_on_instance(receiver)
    }
  }

  def call: args with_receiver: receiver {
    try {
      return call_under(receiver, method() scope(), *args)
    } catch {
      return call_on_instance(receiver, *args)
    }
  }

  def loop {
    wrapper = {
      try {
        call
      } catch (Fancy NextIteration) => ex {
        ex result
      }
    }

    try {
      loop(&wrapper)
    } catch (Fancy BreakIteration) => ex {
      return ex result
    }
  }
}

class Rubinius VariableScope {
  forwards_unary_ruby_methods

  def receiver {
    @self
  }

  def receiver: recv {
    @self = recv
  }
}
