class Module {
  forwards_unary_ruby_methods

  def [constant_name] {
    """
    @constant_name Name (@String@) of constant's name.
    @return @constant_name's value.

    Returns the value of the constant with the given name in @self.
    """

    const_get(constant_name)
  }

  def [constant_name]: value {
    """
    @constant_name Name (@String@) of constant's name.
    @value New value of constant to be used.

    Sets the value of a constant with the given name in @self.
    """

    const_set(constant_name, value)
  }

  def included: module {
    """
    @module @Module@ or @Class@ that has been included into @self.
    Gets called when a @Class@ or @Module@ is included into another @Class@.
    """

    # do nothing by default
    nil
  }
}