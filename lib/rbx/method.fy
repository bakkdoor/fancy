class MethodMixin {
  """
  Mixin class with common methods included by @Method@ and @UnboundMethod@.
  """

  def documentation {
    """
    @return Docstring for @self.
    """

    Fancy Documentation for: (executable())
  }

  def documentation: docstring {
    """
    @docstring New docstring for @self.
    """

    Fancy Documentation for: (executable()) is: docstring
  }

  def visibility {
    """
    @return The visibility (@'private, @'protected, @'public) of a @Method@ in its defined context, if any.
    """
    entry = @defined_in method_table() lookup(@name)
    { entry visibility() } if: entry
  }

  def public? {
    """
    @return @true, if the @Method@ is public in its defined context.
    """
    visibility == 'public
  }

  def protected? {
    """
    @return @true, if the @Method@ is protected in its defined context.
    """
    visibility == 'protected
  }

  def private? {
    """
    @return @true, if the @Method@ is private in its defined context.
    """
    visibility == 'private
  }

  def tests {
    """
    Returns an Array of all the FancySpec SpecTests defined for a
    Method.
    """

    @__method_tests__ =  @__method_tests__ || []
    @__method_tests__
  }

  def test: test_block {
    it = FancySpec new: self
    test_block call: [it]
    tests << it
  }
}

class Method {
  ruby_alias: 'arity
  include: MethodMixin
  forwards_unary_ruby_methods
}

class UnboundMethod {
  """
  An instance UnboundMethod represents a Method object not bound to a specific @Class@ or @Object@.
  """

  ruby_alias: 'arity
  include: MethodMixin
  forwards_unary_ruby_methods
}
