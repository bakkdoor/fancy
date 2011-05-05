require 'bacon'
Bacon.summary_on_exit

module Fancy
  module AST
  end
end

describe 'Literals' do
  # so much fuss just to get debugging working.
  require 'kpeg'
  path = File.expand_path("../../../boot/fancy.kpeg", __FILE__)

  format_parser = KPeg::FormatParser.new(File.read(path))
  format_parser.parse
  @cg = KPeg::CodeGenerator.new("TestFancy", format_parser.grammar, debug = ENV['D'])
  @cg.make('')
  require_relative '../../boot/ast'

  def parse(str)
    parser = @cg.make(str)
    parser.parse.should == true
    parser.result
  end

  def ast(str)
    parse(str).to_ast
  end

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

  it 'parses a = 1' do
    ast('a = 1').should == [[:assign, [:id, "a"], [:int, 1]]]
  end

  it 'parses String' do
    ast('"foo"').should == [[:str, "foo"]]
  end

  it 'parses empty Array' do
    ast('[]').should == [[:arr, []]]
    ast('[ ]').should == [[:arr, []]]
  end

  it 'parses filled Array' do
    ast('[1]').should == [[:arr, [[:int, 1]]]]
  end
end
