require 'bacon'
Bacon.summary_on_exit

module Fancy
  module AST
  end
end

# so much fuss just to get debugging working.
require 'kpeg'
path = File.expand_path("../../../boot/fancy.kpeg", __FILE__)

format_parser = KPeg::FormatParser.new(File.read(path))
format_parser.parse
TestFancyParser = KPeg::CodeGenerator.new("TestFancyParser", format_parser.grammar, debug = ENV['D'])
TestFancyParser.make('')
require File.expand_path('../../../boot/ast', __FILE__)

shared :parser do
  def parse(str)
    parser = TestFancyParser.make(str)
    parser.parse.should == true
    parser.result
  end

  def ast(str)
    parse(str).to_ast
  end
end

describe 'Literals' do
  behaves_like :parser

  it 'parses Integer' do
    ast('1').should == [[:int, 1]]
    ast('+1').should == [[:int, 1]]
    ast('-1').should == [[:int, -1]]
    ast('12').should == [[:int, 12]]
    ast('123').should == [[:int, 123]]
    ast('123_456_789').should == [[:int, 123456789]]
  end

  it 'parses octal integer' do
    ast("0o1151265171444662").should == [[:int, 42424242424242]]
    ast("0O1151265171444662").should == [[:int, 42424242424242]]
  end

  it 'parses hexadecimal integer' do
    ast("0x295860fdc7e1a34b").should == [[:int, 2979237796602028875]]
    ast("0X295860fdc7e1a34b").should == [[:int, 2979237796602028875]]
  end

  it 'parses binary integer' do
    ast("0b101010").should == [[:int, 42]]
    ast("0B101010").should == [[:int, 42]]
  end

  it 'parses Float' do
    ast('1.1').should == [[:float, 1.1]]
    ast('+1.1').should == [[:float, 1.1]]
    ast('-1.1').should == [[:float, -1.1]]
    ast('123_456.789_0').should == [[:float, 123456.7890]]
  end

  it 'parses Identifier' do
    ast('a').should == [[:id, "a"]]
  end

  it 'parses Symbol' do
    ast("'foo").should == [[:sym, "foo"]]
    ast("'foo[]bar*=some:thing?").should == [[:sym, "foo[]bar*=some:thing?"]]
  end

  it 'parses String' do
    ast('"foo"').should == [[:str, "foo"]]
  end

  it 'parses empty Array' do
    ast('[]').should == [[:arr, []]]
    ast('[ ]').should == [[:arr, []]]
  end

  it 'parses single-element Array' do
    ast('[1]').should == [[:arr, [[:int, 1]]]]
    ast('[ 1 ]').should == [[:arr, [[:int, 1]]]]
  end

  it 'parses multi-element Array' do
    ast('[1,2]').should == [[:arr, [[:int, 1], [:int, 2]]]]
    ast('[ 1 , 2 ]').should == [[:arr, [[:int, 1], [:int, 2]]]]
  end

  it 'parses empty Hash' do
    ast('<[]>').should == [[:hash, {}]]
  end

  it 'parses single-element Hash' do
    ast('<[1 => 2]>').should == [[:hash, {[:int, 1] => [:int, 2]}]]
  end

  it 'parses multi-element Hash' do
    ast('<[1 => 2, 3 => 4]>').should == [[:hash, {[:int, 1] => [:int, 2], [:int, 3] => [:int, 4]}]]
  end

  it 'parses empty regexp' do
    ast('//').should == [[:regex, //, ""]]
  end

  it 'parses simple regexp' do
    ast('/foo/').should == [[:regex, /foo/, ""]]
    ast('/foo\s/').should == [[:regex, /foo\s/, ""]]
    ast('/foo\//').should == [[:regex, /foo\//, ""]]
    # ast('/foo(/').should == [[:regex, //]]
  end

  it 'parses tuple' do
    ast('(1,2)').should == [[:tuple, [[:int, 1], [:int, 2]]]]
    ast('( 1 , 2 )').should == [[:tuple, [[:int, 1], [:int, 2]]]]
  end

  it 'parses range' do
    ast('(1..2)').should == [[:range, [:int, 1], [:int, 2]]]
  end

=begin
  it 'parses empty Block' do
    ast('{}').should == [[:block, nil, nil]]
    ast('{ }').should == [[:block, nil, nil]]
  end

  it 'parses standalone Block' do
    ast('{ 1 }').should == [[:block, nil, nil]]
    ast('{1 + 2}').should == [[:block, nil, nil]]
    ast('{ 1 + 2 }').should == [[:block, nil, nil]]
  end

  it 'parses block with parameters' do
    ast('|a| { a * a }').should == []
  end
=end
end

describe 'Method definition' do
  behaves_like :parser
end

describe 'Assignment' do
  behaves_like :parser

  it 'parses a = 1' do
    ast('a = 1').should == [[:assign, [:id, "a"], [:int, 1]]]
  end
end

describe 'Return' do
  behaves_like :parser

  it 'parses return statement' do
    ast('return').should == [[:ret, nil]]
    ast('return 1').should == [[:ret, [:int, 1]]]
  end

  it 'parses local_return statement' do
    ast('return_local').should == [[:retl, nil]]
    ast('return_local 1').should == [[:retl, [:int, 1]]]
  end
end
