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
}