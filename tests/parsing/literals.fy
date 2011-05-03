def require_relative: path {
  require((File expand_path(path, File dirname(__FILE__)) to_s))
}

require_relative: "../../boot/fancy.kpeg"

class String {
  def to_sexp {
    parser = Fancy KPEG new(self)
    parser parse()
    parser output()
  }
}

FancySpec describe: "Parse literals" for: (Fancy KPEG) with: {
  it: "parses literal integer" when: {
    "1"        to_sexp should == [[ 'int, 1 ]]
    "12"       to_sexp should == [[ 'int, 12 ]]
    "123"      to_sexp should == [[ 'int, 123 ]]
    "123_456"  to_sexp should == [[ 'int, 123456 ]]
    "+123_456" to_sexp should == [[ 'int, 123456 ]]
    "-123_456" to_sexp should == [[ 'int, -123456 ]]
  }

  it: "parses literal octal integer" when: {
    "0o1151265171444662" to_sexp should == [[ 'int, 42424242424242 ]]
    "0O1151265171444662" to_sexp should == [[ 'int, 42424242424242 ]]
  }

  it: "parses literal hexadecimal Integer" when: {
    "0x295860fdc7e1a34b" to_sexp should == [[ 'int, 2979237796602028875 ]]
    "0X295860fdc7e1a34b" to_sexp should == [[ 'int, 2979237796602028875 ]]
  }

  it: "parses literal Float" when: {
    "1.2"           to_sexp should == [[ 'float, 1.2 ]]
    "12.3"          to_sexp should == [[ 'float, 12.3 ]]
    "12.34"         to_sexp should == [[ 'float, 12.34 ]]
    "123.456"       to_sexp should == [[ 'float, 123.456 ]]
    "123_456.789_0" to_sexp should == [[ 'float, 123456.789_0 ]]
    "+123.456"      to_sexp should == [[ 'float, 123.456 ]]
    "-123.456"      to_sexp should == [[ 'float, -123.456 ]]
  }

  it: "parses literal Symbol" when: {
    "'foo" to_sexp should == [['sym, 'foo]]
  }
}

"""
require 'bacon'
Bacon.summary_on_exit

module Fancy
end

require_relative '../../boot/fancy.kpeg'

describe Fancy::Parser do
  def parse(str)
    parser = Fancy::Parser.new(str)
    parser.parse
    parser.output
  end

  it 'parses literal Integer' do
    parse('1').should == [[:int, 1]]
    parse('12').should == [[:int, 12]]
    parse('123').should == [[:int, 123]]
    parse('123_456').should == [[:int, 123456]]
    parse('+123_456').should == [[:int, 123456]]
    parse('-123_456').should == [[:int, -123456]]
  end

  it 'parses literal octal Integer' do
    parse('0o1151265171444662').should == [[:int, 42424242424242]]
    parse('0O1151265171444662').should == [[:int, 42424242424242]]
  end

  it 'parses literal hexadecimal Integer' do
    parse('0x295860fdc7e1a34b').should == [[:int, 2979237796602028875]]
    parse('0X295860fdc7e1a34b').should == [[:int, 2979237796602028875]]
  end

  it 'parses literal Float' do
    parse(      '1.2'    ).should == [[:float,      1.2    ]]
    parse(     '12.3'    ).should == [[:float,     12.3    ]]
    parse(     '12.34'   ).should == [[:float,     12.34   ]]
    parse(    '123.456'  ).should == [[:float,    123.456  ]]
    parse('123_456.789_0').should == [[:float, 123456.789_0]]
    parse(   '+123.456'  ).should == [[:float,    123.456  ]]
    parse(   '-123.456'  ).should == [[:float,   -123.456  ]]
  end

  it 'parses literal Symbol' do
    parse("'foo").should == [[:sym, :foo]]
  end
end
"""
