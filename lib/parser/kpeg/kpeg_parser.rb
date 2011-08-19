require 'pp'

# ugh. copied from ruby_lib/fancy.rb ...
class Object
  def fancy_message_args name_and_args
    method_name = []
    args = []
    name_and_args.each_with_index do |a, i|
      if i % 2 == 0
        method_name << a
      else
        args << a
      end
    end
    return [method_name.join(":") + ":", args]
  end

  def fy(*array_or_name)
    if array_or_name.size > 1
      message_name, args = fancy_message_args array_or_name
      self.send(message_name, *args)
    else
      self.send(":#{array_or_name}")
    end
  end
end

class Fancy
  if File.exists? File.expand_path('../fancy.kpeg.rb', __FILE__)
    require File.expand_path('../fancy.kpeg.rb', __FILE__)
  else
    # if no compiled grammar exists, compile it on runtime
    # needs vic/kpeg to live at same level than fancy.

    kpeg_lib = File.expand_path('../../../../../kpeg/lib', __FILE__)
    if File.directory? kpeg_lib
      $LOAD_PATH.unshift kpeg_lib
    else
      require 'rubygems'
      gem 'kpeg'
    end

    require 'kpeg'
    KPeg.compile(File.read(File.expand_path('../fancy.kpeg', __FILE__)),
                 "KPegParser", self)
  end

  class KPegParser
    class NodeToAST
      def initialize(filename = nil)
        @filename = filename
      end
      def to_ast(node, *a)
        return unless node
        if Array === node
          return node.map { |n| to_ast(n) }
        end
        send "#{node.name}_to_ast", node, *a
      end

      def body_to_ast(node)
        AST::ExpressionList.fy :new, node.pos.line, :list, node.args.map { |a| chain_to_ast(a) }
      end

      def chain_to_ast(node)
        ary = node.args.dup
        first = to_ast(ary.shift)
        if ary.empty?
          first
        else
          ary.inject(first) do |receiver, msg|
            to_ast(msg, receiver)
          end
        end
      end

      def ruby_to_ast(node, receiver = nil)
        receiver ||= AST::Self.fy :new, node.pos.line
        ary = node.args[2..-1]

        unless block = node.args[1]
          b = ary.last && ary.last.args.first &&
            ary.last.args.first.args.first
          if b && b.name == :opmsg && b.args.first == "&"
            ary.pop
            block = b.args[1]
          end
        end

        splat = ary.last && ary.last.args.first &&
            ary.last.args.first.args.first
        if splat && splat.name == :opmsg && splat.args.first == "*"
          ary.pop
          splat = splat.args[1]
        else
          splat = nil
        end

        block = to_ast(block)
        splat = to_ast(splat)

        ary = AST::ArrayLiteral.fy :new, node.pos.line, :array, to_ast(ary)
        ruby_args = AST::RubyArgs.fy :new, node.pos.line, :args, ary, :block, block, :splat, splat
#        args = AST::MessageArgs.fy :new, node.pos.line, :args, ruby_args
        id = AST::Identifier.fy :from, node.args[0], :line, node.pos.line
        AST::MessageSend.fy :new, node.pos.line, :message, id, :to, receiver, :args, ruby_args
      end

      def opmsg_to_ast(node, receiver = nil)
        receiver ||= AST::Self.fy :new, node.pos.line
        ary = node.args.dup
        values = ary[1..-1]

        if ary.first == "[]" && ary.length == 3
          name = "[]:"
        else
          name = ary[0]
        end
        values = to_ast(values.compact)
        id = AST::Identifier.fy :from, name, :line, node.pos.line
        args = AST::MessageArgs.fy :new, node.pos.line, :args, values
        AST::MessageSend.fy :new, node.pos.line, :message, id, :to, receiver, :args, args
      end

      def message_to_ast(node, receiver = nil)
        receiver ||= AST::Self.fy :new, node.pos.line
        ary = node.args.dup
        values = []
        names = []
        until (param = ary.shift(2)).empty?
          names << param[0]
          values << param[1]
        end
        name = names.first
        name = [names, ""].flatten.join(":") if node.args.size > 1

        values = to_ast(values.compact)
        id = AST::Identifier.fy :from, name, :line, node.pos.line
        args = AST::MessageArgs.fy :new, node.pos.line, :args, values
        AST::MessageSend.fy :new, node.pos.line, :message, id, :to, receiver, :args, args
      end

      def class_to_ast(node)
        id = to_ast(node.args[0])
        parent = to_ast(node.args[1])
        body = to_ast(node.args[2])
        AST::ClassDef.fy :new, node.pos.line, :name, id, :parent, parent, :body, body
      end

      def method_produce(params, body)
        names = params.args.map { |a| a[0] }.compact
        id = names.first
        id = [names, ""].flatten.join(":") if params.args.first.size > 1
        id = AST::Identifier.fy :from, id, :line, params.pos.line

        args = params.args.map { |a| a[1] }
        args = AST::MethodArgs.fy :new, params.pos.line, :args, args.compact

        body = to_ast(body)
        yield id, args, body
      end

      def method_expand(pos, params, body, &block)
        defs = []
        pars = params.args.dup
        while (par = pars.pop) && !pars.empty? && par[2]
          nv = pars.map { |a| [a[0], Node.new(pos, :ident, a[1])] } +
            [par[0], par[2]]
          fwd = Node.new(pos, :body,
                         Node.new(pos, :chain,
                                  Node.new(pos, :message, *nv.flatten)))
          defs << method_produce(Node.new(pos, :params, *pars), fwd, &block)
        end

        defs << method_produce(params, body, &block)

        AST::ExpressionList.fy :new, defs.last.line, :list, defs
      end

      def method_to_ast(node)
        method_expand(node.pos, node.args[0], node.args[1]) do |id, args, body|
          AST::MethodDef.fy :new, node.pos.line, :name, id, :args, args, :body, body, :access, :public
        end
      end

      def smethod_to_ast(node)
        rec = to_ast(node.args[0])
        method_expand(node.pos, node.args[1], node.args[2]) do |id, args, body|
          AST::SingletonMethodDef.fy :new, node.pos.line, :name, id, :args, args, :body, body, :access, :public, :owner, rec
        end
      end

      def oper_to_ast(node)
        name = node.args[0]
        name = "[]:" if name == "[]" && node.args.length == 4

        id = AST::Identifier.fy :from, name, :line, node.pos.line
        args = AST::MethodArgs.fy :new, node.pos.line, :args, node.args[1..-2]
        body = to_ast(node.args.last)
        AST::MethodDef.fy :new, node.pos.line, :name, id, :args, args, :body, body, :access, :public
      end

      def soper_to_ast(node)
        rec = to_ast(node.args[0])
        name = node.args[1]
        name = "[]:" if name == "[]" && node.args.length == 5

        id = AST::Identifier.fy :from, name, :line, node.pos.line
        args = AST::MethodArgs.fy :new, node.pos.line, :args, node.args[2..-2]
        body = to_ast(node.args.last)

        AST::SingletonMethodDef.fy :new, node.pos.line, :name, id, :args, args, :body, body, :access, :public, :owner, rec
      end

      def assign_to_ast(node)
        AST::Assignment.fy :new, node.pos.line,
                           :var, to_ast(node.args.first),
                           :value, to_ast(node.args.last)
      end

      def massign_to_ast(node)
        AST::MultipleAssignment.fy :new, node.pos.line,
                                   :var, node.args.first.map { |a| to_ast(a) },
                                   :value, node.args.last.map { |a| to_ast(a) }
      end

      def try_to_ast(node)
        body = to_ast(node.args[0])
        handlers = node.args[1].map do |a|
          AST::ExceptionHandler.fy :new, a.pos.line,
                                   :condition, to_ast(a.args[1]),
                                   :var, to_ast(a.args[2]),
                                   :body, to_ast(a.args[0])
        end

        # handlers = AST::Handlers.new(node.pos.line, *node.args[1].map { |a|
        #                                AST::ExceptHandler.new(a.pos.line,
        #                                                       to_ast(a.args[1]),
        #                                                       to_ast(a.args[2]),
        #                                                       to_ast(a.args[0]))
        #                              })

        finally = node.args[2] && to_ast(node.args[2].args.first)
        finally = AST::NilLiteral.fy :new, node.pos.line unless finally
        AST::TryCatch.fy :new, node.pos.line, :body, body, :handlers, handlers, :ensure, finally
      end

      def match_to_ast(node)
        cases = node.args[1..-1].map do |cond|
          AST::MatchClause.fy :new, cond.pos.line,
                              :expr, to_ast(cond.args[0]),
                              :body, to_ast(cond.args[2]),
                              :args, to_ast(cond.args[1])
        end
        AST::Match.fy :new, node.pos.line, :expr, to_ast(node.args.first), :body, cases
      end

      def tuple_to_ast(node)
        AST::TupleLiteral.fy :new, node.pos.line, :entries, to_ast(node.args)
      end

      def array_to_ast(node)
        AST::ArrayLiteral.fy :new, node.pos.line, :array, to_ast(node.args)
      end

      def hash_to_ast(node)
        AST::HashLiteral.fy :new, node.pos.line, :entries, to_ast(node.args)
      end

      def range_to_ast(node)
        from, to = *to_ast(node.args)
        AST::RangeLiteral.fy :new, node.pos.line, :from, from, :to, to
      end

      def block_to_ast(node)
        args = to_ast(node.args.first)
        args = AST::BlockArgs.fy :new, node.pos.line, :args, args
        body = to_ast(node.args.last)
        AST::BlockLiteral.fy :new, node.pos.line, :args, args, :body, body
      end

      def fixnum_to_ast(node)
        AST::FixnumLiteral.fy :new, node.pos.line, :value, node.args.first
      end

      def float_to_ast(node)
        AST::NumberLiteral.fy :new, node.pos.line, :value, node.args.first
      end

      def symbol_to_ast(node)
        AST::SymbolLiteral.fy :new, node.pos.line, :value, node.args.first.to_sym
      end

      def text_to_ast(node)
        AST::StringLiteral.fy :new, node.pos.line, :value, node.args.first
      end

      def regexp_to_ast(node)
        if node.args.size == 1 && node.args.first.name == :text
          AST::RegexpLiteral.fy :new, node.pos.line, :value, node.args.first.args.first
        else
          raise "Not-Implemented: Interpolated regexps"
        end
      end

      def return_to_ast(node)
        value = nil_to_ast(node)
        value = to_ast(node.args.first) if node.args.first
        AST::Return.fy :new, node.pos.line, :expr, value
      end

      def return_local_to_ast(node)
        value = nil_to_ast(node)
        value = to_ast(node.args.first) if node.args.first
        AST::Return.fy :new, node.pos.line, :expr, value
      end

      def const_to_ast(node)
        if node.args.size == 1
          AST::Identifier.fy :from, node.args.first, :line, node.pos.line
        else
          ary = node.args.dup
          first = AST::Identifier.fy :from, ary.shift, :line, node.pos.line
          ary.inject(first) do |parent, name|
            AST::NestedConstant.fy :new, node.pos.line, :const, name.to_sym, :parent, parent
          end
        end
      end

      def self_to_ast(node)
        AST::Self.fy :new, node.pos.line
      end

      def nil_to_ast(node)
        AST::NilLiteral.fy :new, node.pos.line
      end

      def super_to_ast(node)
        AST::Super.fy :new, node.pos.line
      end

      def retry_to_ast(node)
        AST::Retry.fy :new, node.pos.line
      end

      def ident_to_ast(node)
        AST::Identifier.fy :from, node.args.first, :line, node.pos.line, :filename, @filename
      end

      def to_sexp(node)
        if Node === node
          sexp = []
          sexp << node.name if node.name
          sexp.push *to_sexp(node.args)
          sexp
        elsif Array === node
          node.map { |a| to_sexp(a) }
        else
          node
        end
      end

    end
  end


  class Parser
    class ParseError < StandardError; end

    def self.parse_file(filename, lineno = 1, print_sexp=false)
      new(filename, lineno, print_sexp).parse_file.script
    end

    def self.parse_string(code, lineno = 1, filename = "(eval)", print_sexp = false)
      new(filename, lineno, print_sexp).parse_string(code).script
    end


    self.metaclass.send(:define_method, "parse_file:line:") do |filename, lineno|
      parse_file(filename, lineno)
    end
    self.metaclass.send(:define_method, "parse_code:file:line:") do |code, filename, lineno|
      parse_string(code, filename, lineno)
    end

    attr_reader :filename, :lineno, :script

    def initialize(filename, lineno, print_sexp = false)
      @print_sexp = print_sexp
      @filename, @lineno = filename, lineno
    end

    def parse_file
      parse_string(File.read(@filename))
    end

    def parse_string(code)
      parser = KPegParser.new(code)
      unless parser.parse
        parser.show_error
        parser.raise_error
      end
      node = parser.result
      ast = to_ast(node)
      PP.pp(to_sexp(node)) if @print_sexp
      @script = AST::Script.fy :new, node.pos.line, :file, filename, :body, ast
      self
    end

    def to_ast(node)
      KPegParser::NodeToAST.new(@filename).to_ast(node)
    end

    def to_sexp(node)
      KPegParser::NodeToAST.new(@filename).to_sexp(node)
    end

  end

end

