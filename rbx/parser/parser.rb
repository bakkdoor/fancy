require File.dirname(__FILE__) + '/fancy_parser'

module Fancy

  # This module has methods that can be used as callbacks from
  # the parser, so that we can have a relatively simple fancy.y
  # For example, when the parser sees a literal (or any other node)
  # it just calls methods defined here. that create actual
  # Fancy::AST nodes, returning them to the parser to be stored on
  # $$
  module Parser

    class ParseError < StandardError; end

    extend self

    @expr_stack = []

    def push_expression_list(line = 1)
      @expr_stack.push Fancy::AST::ExpressionList.new(line)
    end

    def current_expression_list
      @expr_stack[-1]
    end

    def pop_expression_list
      @expr_stack.pop
    end

    def add_expr(expr)
      current_expression_list.add_expression expr
    end

    def string_literal(line, yytext)
      str = yytext[1..-2] # omit the starting and ending dquotes
      Rubinius::AST::StringLiteral.new(line, str)
    end


    def integer_literal(line, yytext)
      Rubinius::AST::FixnumLiteral.new(line, yytext.to_i)
    end

    def symbol_literal(line, yytext)
      str = yytext[1..-1] # omit the quote
      Rubinius::AST::SymbolLiteral.new(line, str.to_sym)
    end

    def parse_error(line, yytext)
      raise ParseError.new "at line #{line}, token: #{yytext}"
    end

    def identifier(line, yytext)
      Fancy::AST::Identifier.new(line, yytext)
    end

    def msg_send_basic(line, receiver, identifier)
      args = Fancy::AST::MessageArgs.new(line)
      Fancy::AST::MessageSend.new(line, receiver, identifier, args)
    end


  end

end
