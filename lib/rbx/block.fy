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

  def loop {
    wrapper = {
      try {
        call
      } catch (Fancy NextIteration) => ex {
        ex return_value
      }
    }

    try {
      loop(&wrapper)
    } catch (Fancy BreakIteration) => ex {
      return ex return_value
    }
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
