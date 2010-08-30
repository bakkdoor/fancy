def class Method {
  def tests {
    @tests if_nil: { @tests = [] };
    @tests
  }

  def test: test_block {
    it = FancySpec new: self;
    test_block call: it;
    self tests << it
  }
}
