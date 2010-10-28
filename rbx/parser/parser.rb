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
      Fancy::AST::StringLiteral.new(line, str)
    end

    def integer_literal(line, yytext, base = 10)
      Rubinius::AST::FixnumLiteral.new(line, yytext.to_i(base))
    end

    def double_literal(line, yytext)
      Rubinius::AST::NumberLiteral.new(line, yytext.to_f)
    end

    def symbol_literal(line, yytext)
      str = yytext[1..-1] # omit the quote
      Rubinius::AST::SymbolLiteral.new(line, str.to_sym)
    end

    def parse_error(line, yytext)
      raise ParseError.new "Parse error at line #{line}, unexpected token: #{yytext.inspect}"
    end

    def file_error(*error)
      raise ParseError.new error.join(" ")
    end

    def const_identifier(line, identifier, parent = nil)
      if parent
        Rubinius::AST::ScopedConstant.new(line, parent, identifier.name)
      else
        identifier
      end
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

    def multiple_assignment(line, identifiers, values)
      Fancy::AST::MultipleAssignment.new(line, identifiers, values)
    end

    def identifier_list(line, identifier_list, identifier)
      if identifier_list.kind_of?(Array)
        identifier_list.push(identifier)
      else
        [identifier_list, identifier]
      end
    end

    def send_args(line, selector, value, ary = [])
      selector = Fancy::AST::Identifier.new(selector.line, selector.identifier+":")
      ary.push Struct.new(:selector, :value).new(selector, value)
    end

    def operator_def(line, operator, parameter, method_body, access = :public)
      args = Fancy::AST::MethodArgs.new(line, parameter.identifier)
      Fancy::AST::MethodDef.new(line, operator, args, method_body)
    end

    def sin_operator_def(line, identifier, operator, parameter, method_body, access = :public)
      args = Fancy::AST::MethodArgs.new(line, parameter.identifier)
      Fancy::AST::SingletonMethodDef.new(line, identifier, operator, args, method_body)
    end

    def method_def_no_args(line, method_ident, method_body, access = :public)
      args = Fancy::AST::MethodArgs.new(line)
      Fancy::AST::MethodDef.new(line, method_ident, args, method_body)
    end

    def method_arg(line, selector, variable, default = nil)
      selector = Fancy::AST::Identifier.new(selector.line, selector.identifier+":")
      Struct.new(:selector, :variable, :default).new(selector, variable, default)
    end

    def helper_method_name(method_args)
      method_args.map { |a| a.selector.identifier }.join("")
    end

    def expand_method_default(line, method_args, method_body, access)
      el = Fancy::AST::ExpressionList.new(line)
      # Each struct in method_args has a "default" attribute.
      # If != nil, it means that argument has default value.
      # The idea here is to generate as many method_defs
      defaults = method_args.select { |a| a.default }
      non_defaults = method_args.select { |a| a.default.nil? }
      gen_method_args = (non_defaults + defaults[0..-2])
      gen_method_body = Fancy::AST::ExpressionList.new(line)
      gen_msg_send_vars = non_defaults.map{|a| a.variable} + defaults.map{|a| a.default}
      gen_msg_send = Fancy::AST::MessageSend.new(line,
                                                 Rubinius::AST::Self.new(line),
                                                 Fancy::AST::Identifier.new(line, helper_method_name(method_args)),
                                                 Fancy::AST::MessageArgs.new(line, *gen_msg_send_vars))
      gen_method_body.add_expression gen_msg_send
      el.add_expression method_def(line, gen_method_args, gen_method_body, access)
      el
    end

    def method_def(line, method_args, method_body, access = :public)
      # If the method has defaults, generate all alternative methods
      # from it.
      if method_args.select{|a| a.default}.size > 0
        expr_list = expand_method_default(line, method_args, method_body, access)
      else
        expr_list = Fancy::AST::ExpressionList.new(line)
      end

      # This code should be at expand_method_default
      name = helper_method_name(method_args)
      method_ident = Fancy::AST::Identifier.new(line, name)
      args = method_args.map { |a| a.variable.identifier }
      args = Fancy::AST::MethodArgs.new(line, *args)
      method = Fancy::AST::MethodDef.new(line, method_ident, args, method_body)

      # Remember we should return the expression list
      # containing all methods to be defined
      expr_list.add_expression method
      expr_list
    end

    def sin_method_def(line, identifier, method_args, method_body, access = :public)
      name = method_args.map { |a| a.selector.identifier }.join("")
      method_name = Fancy::AST::Identifier.new(line, name)
      args = method_args.map { |a| a.variable.identifier }
      args = Fancy::AST::MethodArgs.new(line, *args)
      Fancy::AST::SingletonMethodDef.new(line, identifier, method_name, args, method_body)
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

    def msg_send_ruby(line, receiver, identifier, args = nil)
      receiver ||= Rubinius::AST::Self.new(line)
      args ||= ruby_args(line)
      arguments = Fancy::AST::MessageArgs.new line, args
      Fancy::AST::MessageSend.new(line, receiver, identifier, arguments)
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

    def expr_list(line, expr = nil, expr_list = nil)
      expr_list = Fancy::AST::ExpressionList.new(line) unless expr_list
      expr_list.add_expression(expr) if expr
      expr_list
    end

    def class_def(line, name, parent, body)
      Fancy::AST::ClassDef.new(line, name, parent, body)
    end

    def expr_ary(line, exp, ary = [])
      if exp.is_a? Array
        ary += exp
      else
        ary.push exp
      end
    end

    def array_literal(line, expr_ary = [])
      Fancy::AST::ArrayLiteral.new(line, *expr_ary)
    end

    def ruby_args(line, array_literal = nil, block = nil)
      if array_literal.kind_of?(Array)
         array_literal = Fancy::AST::ArrayLiteral.new(line, *array_literal)
      end
      if array_literal.nil?
         array_literal = Fancy::AST::ArrayLiteral.new(line)
      end
      Fancy::AST::RubyArgs.new(line, array_literal, block)
    end

    def super_exp(line)
      Fancy::AST::Super.new(line)
    end

    def retry_exp(line)
      Fancy::AST::Retry.new(line)
    end

    def catch_handlers(line, handler = nil, handlers = nil)
      handlers ||= Fancy::AST::Handlers.new(line)
      handlers.add_handler handler if handler
      handlers
    end

    def catch_handler(line, body = nil, condition = nil, var = nil)
      condition ||= Fancy::AST::Identifier.new(line, "Object")
      Fancy::AST::ExceptHandler.new(line, condition, var, body)
    end

    def try_catch_finally(line, body, handlers, finally = nil)
      handlers ||= Fancy::AST::Handlers.new(line)
      Fancy::AST::TryCatchBlock.new(line, body, handlers, finally)
    end

    def key_value_list(line, key, value, ary = [])
      ary.push key
      ary.push value
      ary
    end

    def hash_literal(line, key_values = [])
      Fancy::AST::HashLiteral.new(line, *key_values)
    end

    def regex_literal(line, regexp_str)
      regexp_str = regexp_str[2..-2]
      Rubinius::AST::RegexLiteral.new(line, regexp_str, 0)
    end

    def require_stmt(line, identifier)
      Fancy::AST::Require.new(line, identifier)
    end

    def return_stmt(line, expr = nil)
      expr ||= nil_literal(expr)
      Fancy::AST::Return.new(line, expr)
    end

    def return_local(line, expr = nil)
      expr ||= nil_literal(expr)
      Fancy::AST::Return.new(line, expr)
    end

    def match_expr(line, expr, clauses = nil)
      clauses ||= []
      Fancy::AST::Match.new(line, expr, clauses)
    end

    def match_body(line, match_clause, match_clauses = [])
      match_clauses.push(match_clause)
    end

    def match_clause(line, match_expr, val_expr)
      Fancy::AST::MatchClause.new(line, match_expr, val_expr)
    end
  end

end
