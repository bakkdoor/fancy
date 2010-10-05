require 'parser'

module ParserTestUtils
  def parse(input, rule)
    lexer = Fancy::Lexer.new(input)
    parser = Fancy::Parser.new( lexer )
    parser.send rule
  end

  def test_parse(input, rule)
    tree = parse(input, rule).tree
    success = true
    tree.walk { |e| success = false if e.to_s =~ /^<missing/ }
    success
  end
end
