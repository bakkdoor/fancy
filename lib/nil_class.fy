class NilClass {
  """
  NilClass. The class of the singleton @nil value.
  """

  def NilClass new {
    """
    @return @nil.
    """

    # always return nil singleton object when trying to create a new
    # NilClass instance
    nil
  }

  def if_true: block {
    """
    @return @nil.
    """

    nil
  }

  def if_true: then_block else: else_block {
    """
    @return Value of calling @else_block.

    Calls @else_block.
    """
    else_block call
  }

  def if_nil: block {
    """
    @block @Block@ to be called.
    @return Value of calling @block with @self.

    Calls @block with @self.
    """

    block call: [self]
  }

  def if_nil: then_block else: else_block {
    """
    @then_block @Block@ to be called with @self.
    @else_block Gets ignored.
    @return Value of calling @then_block with @self.

    Calls @then_block with @self.
    """

    then_block call: [self]
  }

  def nil? {
    """
    @return @true.
    """

    true
  }

  def to_s {
    """
    @return An empty @String@.
    """

    ""
  }

  def to_a {
    """
    @return An empty @Array@.
    """

    []
  }

  def not {
    """
    @return @true.
    """

    true
  }

  def inspect {
    """
    @return @nil as a @String@.
    """

    "nil"
  }
}

nil documentation: """
  @nil is the singleton nil value (only instance of @NilClass@).
  NilClass##new yields @nil.
  """
