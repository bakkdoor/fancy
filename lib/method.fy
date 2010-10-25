class Method {
  """
  An instance of Method represents a method on a Class.
  Every method in Fancy is an instance of the Method class.
  """

  def tests {
    """
    Returns an Array of all the FancySpec SpecTests defined for a
    Method.
    """

    @tests if_nil: { @tests = [] }
    @tests
  }

  def test: test_block {
    it = FancySpec new: self
    test_block call: [it]
    self tests << it
  }
}
