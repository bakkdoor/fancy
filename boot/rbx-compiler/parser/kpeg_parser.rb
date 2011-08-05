require 'pp'

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

    KPeg.compile File.read(File.expand_path('../fancy.kpeg', __FILE__)),
                "KPegParser", self
  end

  class KPegParser

    class NodeToAST
      
      def to_ast(node)
        return unless node
        if Array === node
          return node.map { |n| to_ast(n) }
        end
        send "#{node.name}_to_ast", node
      end
      
      def body_to_ast(node)
        AST::ExpressionList.new(node.pos.line,
                                *node.args.map { |a| chain_to_ast(a) })
      end
      
      def chain_to_ast(node)
        ary = node.args.dup
        first = to_ast(ary.shift)
        if ary.empty?
          first
        else
          ary.inject(first) do |receiver, msg|
            message_to_ast(msg, receiver)
          end
        end
      end

      def ruby_to_ast(node, receiver = nil)
        receiver ||= AST::Self.new(node.pos.line)
        ary = node.args[1..-1]
        block = ary.last && ary.last.args.first && ary.last.args.first.args.first
        if block && block.name == :message && block.args.first == "&"
          ary.pop
          block = to_ast(block.args[1])
        else
          block = nil
        end
        ary = AST::ArrayLiteral.new(node.pos.line, *to_ast(ary))
        args = AST::MessageArgs.new(node.pos.line,
                                    AST::RubyArgs.new(node.pos.line, ary, block))
        id = AST::Identifier.new(node.pos.line, node.args[0])
        AST::MessageSend.new(node.pos.line, receiver, id, args)
      end

      def message_to_ast(node, receiver = nil)
        receiver ||= AST::Self.new(node.pos.line)
        ary = node.args.dup
        values = []

        if ary.first == "[]"
          name = if ary.length == 2 then "[]" else "[]:" end
          values = ary[1..-1]
        else
          names = []
          until (param = ary.shift(2)).empty?
            names << param[0]
            values << param[1]
          end
          name = names.first
          name = [names, ""].flatten.join(":") if node.args.size > 1
        end
        
        values = to_ast(values.compact)
        id = AST::Identifier.new(node.pos.line, name)
        args = AST::MessageArgs.new(node.pos.line, *values)
        AST::MessageSend.new(node.pos.line, receiver, id, args)
      end

      def class_to_ast(node)
        id = to_ast(node.args[0])
        parent = to_ast(node.args[1])
        body = to_ast(node.args[2])
        AST::ClassDef.new(node.pos.line, id, parent, body)
      end

      def method_produce(params, body)
        names = params.args.map { |a| a[0] }.compact
        id = names.first
        id = [names, ""].flatten.join(":") if params.args.first.size > 1
        id = AST::Identifier.new(params.pos.line, id)

        args = params.args.map { |a| a[1] }
        args = AST::MethodArgs.new(params.pos.line, *args.compact)
        
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

        AST::ExpressionList.new(defs.last.line, *defs)
      end

      def method_to_ast(node)
        method_expand(node.pos, node.args[0], node.args[1]) do |id, args, body|
          AST::MethodDef.new(node.pos.line, id, args, body, :public)
        end
      end

      def smethod_to_ast(node)
        rec = to_ast(node.args[0])
        method_expand(node.pos, node.args[1], node.args[2]) do |id, args, body|
          AST::SingletonMethodDef.new(node.pos.line, rec, id, args, body, :public)
        end
      end

      def oper_to_ast(node)
        name = node.args[0]
        name = "[]:" if name == "[]" && node.args.length == 4
        
        id = AST::Identifier.new(node.pos.line, name)
        args = AST::MethodArgs.new(node.pos.line, *node.args[1..-2])
        body = to_ast(node.args.last)
        AST::MethodDef.new(node.pos.line, id, args, body, :public)
      end
      
      def soper_to_ast(node)
        rec = to_ast(node.args[0])
        
        name = node.args[1]
        name = "[]:" if name == "[]" && node.args.length == 5
        
        id = AST::Identifier.new(node.pos.line, name)
        args = AST::MethodArgs.new(node.pos.line, *node.args[2..-2])
        body = to_ast(node.args.last)

        AST::SingletonMethodDef.new(node.pos.line, rec, id, args, body, :public)
      end

      def assign_to_ast(node)
        AST::Assignment.new(node.pos.line,
                            to_ast(node.args.first),
                            to_ast(node.args.last))
      end
      def massign_to_ast(node)
        AST::MultipleAssignment.new(node.pos.line,
                                    node.args.first.map { |a| to_ast(a) },
                                    node.args.last.map { |a| to_ast(a) })
      end

      def try_to_ast(node)
        PP.pp(to_sexp(node)) unless Array === node.args[1]
        body = to_ast(node.args[0])
        handlers = AST::Handlers.new(node.pos.line, *node.args[1].map { |a|
                                       AST::ExceptHandler.new(a.pos.line,
                                                              to_ast(a.args[1]),
                                                              to_ast(a.args[2]),
                                                              to_ast(a.args[0]))
                                     })
        finally = nil
        finally = node.args[2] && to_ast(node.args[2].args.first)
        AST::TryCatchBlock.new(node.pos.line, body, handlers, finally)
      end

      def match_to_ast(node)
        cases = node.args[1..-1].map do |cond|          
          AST::MatchClause.new(cond.pos.line,
                               to_ast(cond.args[0]),
                               to_ast(cond.args[2]),
                               to_ast(cond.args[1]))
        end
        AST::Match.new(node.pos.line, to_ast(node.args.first), cases)
      end

      def tuple_to_ast(node)
        AST::TupleLiteral.new(node.pos.line, *to_ast(node.args))
      end
      
      def array_to_ast(node)
        AST::ArrayLiteral.new(node.pos.line, *to_ast(node.args))
      end

      def hash_to_ast(node)
        AST::HashLiteral.new(node.pos.line, *to_ast(node.args))
      end

      def range_to_ast(node)
        AST::RangeLiteral.new(node.pos.line, *to_ast(node.args))
      end

      def block_to_ast(node)
        args = to_ast(node.args.first)
        args = AST::BlockArgs.new node.pos.line, *args
        body = to_ast(node.args.last)
        AST::BlockLiteral.new(node.pos.line, args, body)
      end

      def fixnum_to_ast(node)
        AST::FixnumLiteral.new(node.pos.line, node.args.first)
      end

      def float_to_ast(node)
        AST::NumberLiteral.new(node.pos.line, node.args.first)
      end

      def symbol_to_ast(node)
        AST::SymbolLiteral.new(node.pos.line, node.args.first.to_sym)
      end

      def text_to_ast(node)
        AST::StringLiteral.new(node.pos.line, node.args.first)
      end

      def regexp_to_ast(node)
        if node.args.size == 1 && node.args.first.name == :text
          AST::RegexLiteral.new(node.pos.line, node.args.first.args.first, 0)
        else
          raise "Not-Implemented: Interpolated regexps"
        end
      end

      def return_to_ast(node)
        value = nil_to_ast(node)
        value = to_ast(node.args.first) if node.args.first
        AST::Return.new(node.pos.line, value)
      end

      def return_local_to_ast(node)
        value = nil_to_ast(node)
        value = to_ast(node.args.first) if node.args.first
        AST::Return.new(node.pos.line, value)
      end

      def const_to_ast(node)
        if node.args.size == 1
          AST::Identifier.new(node.pos.line, node.args.first)
        else
          ary = node.args.dup
          first = AST::Identifier.new(node.pos.line, ary.shift)
          ary.inject(first) do |parent, name|
            id = AST::Identifier.new(node.pos.line, name)
            AST::ScopedConstant.new(node.pos.line, id, parent.name)
          end
        end
      end

      def self_to_ast(node)
        AST::Self.new(node.pos.line)
      end

      def nil_to_ast(node)
        Rubinius::AST::NilLiteral.new(node.pos.line)
      end

      def super_to_ast(node)
        AST::Super.new(node.pos.line)
      end

      def retry_to_ast(node)
        AST::Retry.new(node.pos.line)
      end

      def ident_to_ast(node)
        AST::Identifier.new(node.pos.line, node.args.first)
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
    def parse_file
      parse_string(File.read(filename), filename)
    end

    def parse_string(code, filename)
      parser = KPegParser.new(code)
      unless parser.parse
        parser.show_error
        parser.raise_error
      end
      node = parser.result
      ast = to_ast(node)
      #PP.pp(to_sexp(node))
      @script = AST::Script.new(node.pos.line, filename, ast)
      self
    end
        
    def to_ast(node)
      KPegParser::NodeToAST.new.to_ast(node)
    end

    def to_sexp(node)
      KPegParser::NodeToAST.new.to_sexp(node)
    end

  end
  
end

