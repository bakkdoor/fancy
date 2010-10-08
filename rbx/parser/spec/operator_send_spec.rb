describe Fancy::Parser, "when parsing operator sends." do
  include ParserTestUtils

  it "should parse operator sends to literal_values" do
    test_parse("1 + 1", :operator_send).should be_true
    test_parse("1.0 + 1", :operator_send).should be_true
    test_parse("1_000 + 1", :operator_send).should be_true
  end

  it "should parse operator sends to identifiers" do
    test_parse("a + 1", :operator_send).should be_true
  end

  it "should parse nested operator sends" do
    test_parse("(1 + 1) + 1", :operator_send).should be_true
    test_parse("1 + (1 + 1)", :operator_send).should be_true
  end

end

