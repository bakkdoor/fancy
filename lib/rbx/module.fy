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
  
  def overwrite_method: name with_dynamic: block {
    prev = nil
    try {
      # Try to get a previous documentation instance so that we don't overwrite it.
      prev = self method_table lookup(name) method() documentation
    } catch ArgumentError => e { }
    # Call to Rubinius to set up the method.
    code = self dynamic_method(name, &block)

    if: prev then: {
      # Janky since docs method isn't always available when this is called.
      docstring = prev instance_variable_get('@docs)
      self method_table lookup(name) method() documentation: docstring
    }
    return code
  }
}
