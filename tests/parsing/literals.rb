require 'bacon'
Bacon.summary_on_exit

module Fancy
  module AST
  end
end

require_relative '../../boot/fancy.kpeg'

module Fancy
  module AST
    class ExpressionList
      def to_ast
        [car.to_ast, *cdr]
      end
    end

    class Identifier
      def to_ast
        [:id, id]
      end
    end

    class Integer
      def to_ast
        [:int, n.to_i(base)]
      end
    end

    class Code
      def to_ast
        [:code, code.to_ast]
      end
    end

    class Assignment
      def to_ast
        [:assign, id.to_ast, obj.to_ast]
      end
    end
  end
end

describe 'Literals' do
  # so much fuss just to get debugging working.
  def parse(str, debug = true)
    require 'kpeg'
    path = File.expand_path("../../../boot/fancy.kpeg", __FILE__)

    parser = KPeg::FormatParser.new(File.read(path))
    parser.parse
    cg = KPeg::CodeGenerator.new("TestFancy", parser.grammar, debug)
    parser = cg.make(str)
    parser.parse.should == true
    parser.result
  end

  def ast(str)
    parse(str, debug = false).to_ast
  end

  it 'parses Integer' do
    ast('1').should == [[:int, 1]]
    ast('12').should == [[:int, 12]]
  end

  it 'parses Identifier' do
    ast('a').should == [[:id, "a"]]
  end

  it 'parses a = 1' do
    ast('a = 1').should == [[:assign, [:id, "a"], [:int, 1]]]
  end
end
