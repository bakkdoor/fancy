describe Fancy::Parser, "when parsing assignments" do
  include ParserTestUtils

  it "should parse a = 10" do
    test_parse("a = 10", :assignment).should be_true
  end

  it "should parse @a = c" do
    test_parse("@a = c", :assignment).should be_true
  end

  it "should not parse a= 10" do
    test_parse("a= 10", :assignment).should be_false
  end

end

