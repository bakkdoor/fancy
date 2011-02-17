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
}

class Rubinius VariableScope {
  def receiver {
    @self
  }

  def receiver: recv {
    @self = recv
  }
}