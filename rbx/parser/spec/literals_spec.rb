describe Fancy::Parser, "when parsing literals" do
  include ParserTestUtils

  it "should parse integer literals" do
    test_parse("123", :int_lit).should be_true
    test_parse("123_456", :int_lit).should be_true
  end

  it "should not parse something which is not an int_lit else as int_lit" do
    test_parse("12l3kj12lk3j", :int_lit).should be_false
    test_parse("123.123", :int_lit).should be_false
    test_parse("'blablubber", :int_lit).should be_false
  end

  it "should parse double literals" do
    test_parse("123.123", :double_lit).should be_true
    test_parse("123_123.123", :double_lit).should be_true
  end

  it "should not parse something which is not a double_lit as double_lit" do
    test_parse("alksjd", :double_lit).should be_false
    test_parse("12345", :double_lit).should be_false
    test_parse("123_345", :double_lit).should be_false
  end


end

