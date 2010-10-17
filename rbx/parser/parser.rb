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

    def double_literal(line, yytext)
      Rubinius::AST::NumberLiteral.new(line, yytext.to_f)
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

    def oper_send_basic(line, receiver, operator, argument)
      args = Fancy::AST::MessageArgs.new(line, argument)
      Fancy::AST::MessageSend.new(line, receiver, operator, args)
    end

    def assignment(line, identifier, value)
      Fancy::AST::Assignment.new(line, identifier, value)
    end

    def multiple_assignment(line, identifier, value)
      raise "Implement multiple_assignment node"
    end

    def identifier_list(line, identifier_list, identifier)
      if identifier_list.kind_of?(Array)
        identifier_list.push(identifier)
      else
        [identifier_list, identifier]
      end
    end

    def method_args(line, selector, variable, ary = [])
      selector = Fancy::AST::Identifier.new(selector.line, selector.identifier+":")
      ary.push Struct.new(:selector, :variable).new(selector, variable)
    end

    def send_args(line, selector, value, ary = [])
      selector = Fancy::AST::Identifier.new(selector.line, selector.identifier+":")
      ary.push Struct.new(:selector, :value).new(selector, value)
    end

    def method_def(line, method_args, method_body)
      name = method_args.map { |a| a.selector.identifier }.join("")
      method_ident = Fancy::AST::Identifier.new(line, name)
      args = method_args.map { |a| a.selector.identifier }
      args = Fancy::AST::MethodArgs.new(line, *args)
      Fancy::AST::MethodDef.new(line, method_ident, args, method_body)
    end

    def msg_send_args(line, receiver, method_args)
      receiver ||= Rubinius::AST::Self.new(line)
      name = method_args.map { |a| a.selector.identifier }.join("")
      name = Fancy::AST::Identifier.new(line, name)
      args = Fancy::AST::MessageArgs.new line, *method_args.map { |a| a.value }
      Fancy::AST::MessageSend.new(line, receiver, name, args)
    end

    def nil_literal(line)
      Rubinius::AST::NilLiteral.new(line)
    end
  end

end
