class MethodMixin {
  def documentation {
    Fancy Documentation for: (executable())
  }

  def documentation: str {
    Fancy Documentation for: (executable()) is: str
  }

  def visibility {
    """
    Returns the visibility ('private, 'protected, 'public) of a @Method@ in its defined context, if any.
    """
    entry = @defined_in method_table() lookup(@name)
    { entry visibility() } if: entry
  }

  def public? {
    """
    Returns true, if the @Method@ is public in its defined context.
    """
    visibility == 'public
  }

  def protected? {
    """
    Returns true, if the @Method@ is protected in its defined context.
    """
    visibility == 'protected
  }

  def private? {
    """
    Returns true, if the @Method@ is private in its defined context.
    """
    visibility == 'private
  }
}

class Method {
  ruby_alias: 'arity
  include: MethodMixin
}

class UnboundMethod {
  ruby_alias: 'arity
  include: MethodMixin
}

