
class Fancy

  # This module has methods that can be used as callbacks from
  # the parser, so that we can have a relatively simple fancy.y
  # For example, when the parser sees a literal (or any other node)
  # it just calls methods defined here. that create actual
  # AST nodes, returning them to the parser to be stored on
  # $$
  class Parser

    class ParseError < StandardError; end

    def self.parse_file(filename, lineno = 1)
      new(filename, lineno).parse_file.script
    end

    def self.parse_string(code, lineno = 1, filename = "(eval)")
      new(filename, lineno).parse_string(code).script
    end

    attr_reader :filename, :lineno, :script

    def initialize(filename, lineno)
      @filename, @lineno = filename, lineno
    end

    def body=(expression_list)
      @script = AST::Script.new(lineno, filename, expression_list)
    end

    def string_literal(line, yytext)
      str = yytext[1..-2] # omit the starting and ending quotes
      AST::StringLiteral.new(line, str)
    end

    def multiline_string_literal(line, yytext)
      str = yytext[3..-4] # omit the starting and ending triple-quotes
      AST::StringLiteral.new(line, str)
    end

    def integer_literal(line, yytext, base = 10)
      AST::FixnumLiteral.new(line, yytext.to_i(base))
    end

    def double_literal(line, yytext)
      AST::NumberLiteral.new(line, yytext.to_f)
    end

    def symbol_literal(line, yytext)
      str = yytext[1..-1] # omit the quote
      AST::SymbolLiteral.new(line, str.to_sym)
    end

    def parse_error(line, yytext)
      raise ParseError.new "Parse error at line #{line}, unexpected token: #{yytext.inspect}"
    end

    def file_error(*error)
      raise ParseError.new error.join(" ")
    end

    def const_identifier(line, identifier, parent = nil)
      if parent
        AST::ScopedConstant.new(line, parent, identifier.name)
      else
        identifier
      end
    end

    def ruby_send_open(line, yytext)
      # A ruby send is identified by the parser by seeing an
      # identifier immediatly followed by a left-paren.
      # NO SPACE IS ALLOWED BETWEEN THEM.
      # So the parser gives yytext as the identifier with its
      # left-paren as last character.
      # Remove the paren and simply create an identifier.
      identifier(line, yytext[0..-2])
    end

    def identifier(line, yytext)
      if yytext == "self"
        AST::Self.new(line)
      else
        AST::Identifier.new(line, yytext)
      end
    end

    def msg_send_basic(line, receiver, identifier)
      args = AST::MessageArgs.new(line)
      AST::MessageSend.new(line, receiver, identifier, args)
    end

    def oper_send_basic(line, receiver, operator, argument)
      args = AST::MessageArgs.new(line, argument)
      AST::MessageSend.new(line, receiver, operator, args)
    end

    def oper_send_multi(line, receiver, operator, *arguments)
      args = AST::MessageArgs.new(line, *arguments)
      AST::MessageSend.new(line, receiver, operator, args)
    end

    def assignment(line, identifier, value)
      AST::Assignment.new(line, identifier, value)
    end

    def multiple_assignment(line, identifiers, values)
      AST::MultipleAssignment.new(line, identifiers, values)
    end

    def identifier_list(line, identifier_list, identifier)
      if identifier_list.kind_of?(Array)
        identifier_list.push(identifier)
      else
        [identifier_list, identifier]
      end
    end

    def send_args(line, selector, value, ary = [])
      selector = AST::Identifier.new(selector.line, selector.identifier+":")
      ary.push Struct.new(:selector, :value).new(selector, value)
    end

    def operator_def(line, operator, parameter, method_body, access = :public)
      args = AST::MethodArgs.new(line, parameter.identifier)
      AST::MethodDef.new(line, operator, args, method_body, access)
    end

    def operator_def_multi(line, operator, method_body, access = :public, *parameters)
      args = AST::MethodArgs.new(line, *parameters.map(&:identifier))
      AST::MethodDef.new(line, operator, args, method_body, access)
    end

    def sin_operator_def(line, identifier, operator, parameter, method_body, access = :public)
      args = AST::MethodArgs.new(line, parameter.identifier)
      AST::SingletonMethodDef.new(line, identifier, operator, args, method_body, access)
    end

    def sin_operator_def_multi(line, identifier, operator, method_body, access = :public, *parameters)
      args = AST::MethodArgs.new(line, *parameters.map(&:identifier))
      AST::SingletonMethodDef.new(line, identifier, operator, args, method_body, access)
    end

    def method_def_no_args(line, method_ident, method_body, access = :public)
      args = AST::MethodArgs.new(line)
      AST::MethodDef.new(line, method_ident, args, method_body, access)
    end

    def method_arg(line, selector, variable, default = nil)
      selector = AST::Identifier.new(selector.line, selector.identifier+":")
      Struct.new(:selector, :variable, :default).new(selector, variable, default)
    end

    def helper_method_name(method_args)
      method_args.map { |a| a.selector.identifier }.join("")
    end

    # Creates a single MethodDef node.
    def method_def(line, method_args, method_body, access)
      name = helper_method_name(method_args)
      method_ident = AST::Identifier.new(line, name)
      args = method_args.map { |a| a.variable.identifier }
      args = AST::MethodArgs.new(line, *args)
      AST::MethodDef.new(line, method_ident, args, method_body, access)
    end

    def method_delegators(method_args)
      # find the first default argument
      idx = method_args.index { |a| a.default }
      return unless idx

      line = method_args.first.selector.line
      target = helper_method_name(method_args)

      (method_args.size - idx).times do |pos|

        required = method_args[0...idx+pos]
        default = method_args[idx+pos..-1]

        params = required.map(&:variable) + default.map(&:default)

        forward = AST::MessageSend.new(line,
                                              AST::Self.new(line),
                                              AST::Identifier.new(line, target),
                                              AST::MessageArgs.new(line, *params))
        doc = AST::StringLiteral.new(line, "Forward to message #{target}")
        body = AST::ExpressionList.new(line, doc, forward)

        yield required, body
      end
    end


    # Generate an expression list of method_defs
    def method_def_expand(line, method_args, method_body, access = :public)
      defs = []
      method_delegators(method_args) do |sel, fwd|
        defs << method_def(line, sel, fwd, access)
      end
      defs << method_def(line, method_args, method_body, access)
      AST::ExpressionList.new(line, *defs)
    end

    def sin_method_def_expand(line, identifier, method_args, method_body, access = :public)
      defs = []
      method_delegators(method_args) do |sel, fwd|
        defs << sin_method_def(line, identifier, sel, fwd, access)
      end
      defs << sin_method_def(line, identifier, method_args, method_body, access)
      AST::ExpressionList.new(line, *defs)
    end

    def sin_method_def(line, identifier, method_args, method_body, access = :public)
      name = method_args.map { |a| a.selector.identifier }.join("")
      method_name = AST::Identifier.new(line, name)
      args = method_args.map { |a| a.variable.identifier }
      args = AST::MethodArgs.new(line, *args)
      AST::SingletonMethodDef.new(line, identifier, method_name, args, method_body, access)
    end

    def sin_method_def_no_args(line, identifier, method_name, method_body, access = :public)
      args = AST::MethodArgs.new(line)
      AST::SingletonMethodDef.new(line, identifier, method_name, args, method_body, access)
    end

    def msg_send_args(line, receiver, method_args)
      receiver ||= AST::Self.new(line)
      name = method_args.map { |a| a.selector.identifier }.join("")
      name = AST::Identifier.new(line, name)
      args = AST::MessageArgs.new line, *method_args.map { |a| a.value }
      AST::MessageSend.new(line, receiver, name, args)
    end

    def msg_send_ruby(line, receiver, identifier, args = nil)
      receiver ||= AST::Self.new(line)
      args ||= ruby_args(line)
      arguments = AST::MessageArgs.new line, args
      AST::MessageSend.new(line, receiver, identifier, arguments)
    end

    def nil_literal(line)
      Rubinius::ToolSet.current::TS::AST::NilLiteral.new(line)
    end

    def partial_block(line, block_body)
      gen_blockarg = AST::Identifier.generate(line)
      args = AST::BlockArgs.new line, gen_blockarg
      AST::BlockLiteral.new(line, args, block_body, true)
    end

    def block_literal(line, block_args, block_body)
      block_args ||= Array.new
      args = AST::BlockArgs.new line, *block_args
      AST::BlockLiteral.new(line, args, block_body)
    end

    def tuple_literal(line, expr_ary = [])
      # when we have a tuple with 1 element, it's not actually a tuple
      # but a grouped expression, e.g. (obj foo: bar)
      # 1-tuples don't make much sense anyway, so we won't support
      # them via tuple literal syntax.
      if expr_ary.size == 1
        expr_ary.first
      else
        AST::TupleLiteral.new(line, *expr_ary)
      end
    end

    def range_literal(line, from, to)
      AST::RangeLiteral.new(line, from, to)
    end

    def block_args(line, identifier, ary = [])
      ary.push identifier
    end

    def expr_list(line, expr = nil, expr_list = nil)
      expr_list = AST::ExpressionList.new(line) unless expr_list
      expr_list.add_expression(expr) if expr
      expr_list
    end

    def class_def(line, name, parent, body = nil)
      AST::ClassDef.new(line, name, parent, body)
    end

    def expr_ary(line, exp, ary = [])
      if exp.is_a? Array
        ary += exp
      else
        ary.push exp
      end
    end

    def array_literal(line, expr_ary = [])
      AST::ArrayLiteral.new(line, *expr_ary)
    end

    def ruby_args(line, array_literal = nil, block = nil)
      if array_literal.kind_of?(Array)
         array_literal = AST::ArrayLiteral.new(line, *array_literal)
      end
      if array_literal.nil?
         array_literal = AST::ArrayLiteral.new(line)
      end
      AST::RubyArgs.new(line, array_literal, block)
    end

    def super_exp(line)
      AST::Super.new(line)
    end

    def retry_exp(line)
      AST::Retry.new(line)
    end

    def catch_handlers(line, handler = nil, handlers = nil)
      handlers ||= AST::Handlers.new(line)
      handlers.add_handler handler if handler
      handlers
    end

    def catch_handler(line, body = nil, condition = nil, var = nil)
      condition ||= AST::Identifier.new(line, "Object")
      AST::ExceptHandler.new(line, condition, var, body)
    end

    def try_catch_finally(line, body, handlers, finally = nil)
      handlers ||= AST::Handlers.new(line)
      AST::TryCatchBlock.new(line, body, handlers, finally)
    end

    def key_value_list(line, key, value, ary = [])
      ary.push key
      ary.push value
      ary
    end

    def hash_literal(line, key_values = [])
      AST::HashLiteral.new(line, *key_values)
    end

    def regex_literal(line, regexp_str)
      regexp_str = regexp_str[1..-2]
      AST::RegexLiteral.new(line, regexp_str, 0)
    end

    def return_stmt(line, expr = nil)
      expr ||= nil_literal(expr)
      AST::Return.new(line, expr)
    end

    def return_local(line, expr = nil)
      expr ||= nil_literal(expr)
      AST::Return.new(line, expr)
    end

    def match_expr(line, expr, clauses = nil)
      clauses ||= []
      AST::Match.new(line, expr, clauses)
    end

    def match_body(line, match_clause, match_clauses = [])
      match_clauses.push(match_clause)
    end

    def match_clause(line, match_expr, val_expr, match_args=[])
      AST::MatchClause.new(line, match_expr, val_expr, match_args)
    end
  end

end
