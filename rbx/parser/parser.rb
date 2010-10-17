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
      @expr_stack.push expr_list(line)
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
      if yytext == "self"
        Rubinius::AST::Self.new(line)
      else
        Fancy::AST::Identifier.new(line, yytext)
      end
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

    def method_def_no_args(line, method_ident, method_body, access = :public)
      args = Fancy::AST::MethodArgs.new(line)
      Fancy::AST::MethodDef.new(line, method_ident, args, method_body)
    end

    def method_def(line, method_args, method_body, access = :public)
      name = method_args.map { |a| a.selector.identifier }.join("")
      method_ident = Fancy::AST::Identifier.new(line, name)
      args = method_args.map { |a| a.variable.identifier }
      args = Fancy::AST::MethodArgs.new(line, *args)
      Fancy::AST::MethodDef.new(line, method_ident, args, method_body)
    end

    def sin_method_def_no_args(line, identifier, method_name, method_body, access = :public)
      args = Fancy::AST::MethodArgs.new(line)
      Fancy::AST::SingletonMethodDef.new(line, identifier, method_name, args, method_body)
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

    def block_literal(line, block_args, block_body)
      block_args ||= Array.new
      args = Fancy::AST::BlockArgs.new line, *block_args
      Fancy::AST::BlockLiteral.new(line, args, block_body)
    end

    def block_args(line, identifier, ary = [])
      ary.push identifier
    end

    def expr_list(line, *expressions)
      Fancy::AST::ExpressionList.new(line, *expressions)
    end

    def class_def(line, identifier, parent, body)
      Fancy::AST::ClassDef.new(line, identifier, parent, body)
    end

    def array_empty(line)
      Fancy::AST::ArrayLiteral.new(line)
    end

    def expr_ary(line, exp, ary = [])
      ary.push exp
    end

    def array_literal(line, expr_ary)
      Fancy::AST::ArrayLiteral.new(line, *expr_ary)
    end

    def ruby_args(line, array_literal)
      Fancy::AST::RubyArgs.new(line, array_literal)
    end

    def method_body(line, expr_list, code)
      expr_list.add_expression code
      expr_list
    end

    def super_exp(line)
      Fancy::AST::Super.new(line)
    end

    def retry_exp(line)
      Fancy::AST::Retry.new(line)
    end

    def catch_handler(line, body = nil, condition = nil, var = nil, handlers = nil)
      handlers ||= Fancy::AST::Handlers.new(line)
      handler = Fancy::AST::ExceptHandler.new(line, condition, var, body)
      handlers.add_handler handler
      handlers
    end

    def try_catch_finally(line, body, handlers, finally = nil)
      Fancy::AST::TryCatchBlock.new(line, body, handlers, finally)
    end

  end

end
