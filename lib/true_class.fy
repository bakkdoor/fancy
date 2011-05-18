class TrueClass {
  "TrueClass. The class of the singleton @true value."

  def TrueClass new {
    """
    @return @true.
    """

    # always return true singleton object when trying to create a new
    # TrueClass instance
    true
  }

  def if_true: block {
    """
    @block @Block@ to be called with @self.
    @return Value of calling @block with @self.

    Calls @block with @self.
    """

    block call: [self]
  }

  def if_true: then_block else: else_block {
    """
    @then_block @Block@ to be called with @self.
    @else_block Gets ignored.
    @return Value of calling @then_block with @self.

    Calls @then_block with @self.
    """

    then_block call: [self]
  }

  def true? {
    """
    @return @true.
    """

    true
  }

  def to_s {
    """
    @return @true as a @String@.
    """

    "true"
  }

  def to_a {
    """
    @return An empty @Array@.
    """

    []
  }

  def not {
    """
    @return @false.
    """

    false
  }
}
