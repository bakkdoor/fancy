require 'parser'

module ParserTestUtils
  def parse(input, rule)
    lexer = Fancy::Lexer.new(input)
    parser = Fancy::Parser.new( lexer )
    parser.send rule
  end

  def test_parse(input, rule)
    tmp = $stderr

    s = StringIO.new
    $stderr = s
    tree = parse(input, rule)

    $stderr = tmp
    s.size == 0
  end

end
