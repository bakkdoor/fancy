# -*- coding: utf-8 -*-
describe Fancy::Parser, "when parsing message_sends" do
  include ParserTestUtils

  it "should parse message sends with no args" do
    test_parse("foo bar", :message_send).should be_true
    test_parse("foo bar baz", :message_send).should be_true
    test_parse("foo bar baz  bat", :message_send).should be_true
  end

  it "should parse message sends with args" do
    test_parse("foo bar: 123 foo: 123.123 baz: 'sym", :message_send).should be_true
  end

end
