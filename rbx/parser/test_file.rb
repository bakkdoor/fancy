require "rubygems"
require "antlr3"
require "FancyParser"
require "FancyLexer"
require "../rsexp_pretty_printer"

def parse(src, rule=:program)
  if File.exists? src
    input = ANTLR3::FileStream.new(src)
  elsif src.is_a? String
    input = ANTLR3::StringStream.new(src)
  end

  lexer = Fancy::Lexer.new input
  parser = Fancy::Parser.new lexer

  parser.send rule
end

if __FILE__ == $0
  if ARGV[1]
    erg = parse ARGV[0], ARGV[1].to_sym
  else
    erg = parse ARGV[0]
  end

  p = Fancy::RSexpPrettyPrinter.new
  p.nice erg
end
