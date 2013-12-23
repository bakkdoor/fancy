class Regexp {
  ruby_alias: 'inspect
  ruby_alias: 'to_s

  alias_method: 'match: for_ruby: 'match
  alias_method: '=== for_ruby: 'match

  def i {
    Regexp new(source(), true)
  }

  def m {
    Regexp new(source(), Regexp MULTILINE)
  }

  def x {
    Regexp new(source(), Regexp EXTENDED)
  }

  def Regexp new: pattern {
    """
    @pattern @String@ pattern to create @Regexp@ from.

    Creates a new @Regexp@ from @pattern.
    """

    new(pattern)
  }
}
