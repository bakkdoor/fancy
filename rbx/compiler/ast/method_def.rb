module Fancy
  module AST

    class MethodDef < Rubinius::AST::Define
      def initialize(line, method_ident, args, body)
        @line = line
        @name = method_ident.method_name
        @arguments = args
        @body = body
        generate_ivar_assignment
      end

      def generate_ivar_assignment
        @arguments.required.reverse.each do |name|
          if name.to_s =~ /^@/
            ident = Fancy::AST::Identifier.new(line, name.to_s)
            value = Rubinius::AST::LocalVariableAccess.new(line, name)
            asign = Fancy::AST::Assignment.new(line, ident, value)
            body.unshift_expression(asign)
          end
        end
      end

      def bytecode(g)
        if @name.to_s =~ /^initialize:(\S)+/
          define_constructor_class_method g
        end
        super(g)
      end

      # defines a class method names "new:foo:" if we're defining a
      # method named e.g. "initialize:foo:" (a constructor method).
      def define_constructor_class_method(g)
        method_ident = Rubinius::AST::StringLiteral.new(@line, @name.to_s[11..-1])
        ms = MessageSend.new(@line,
                             Rubinius::AST::Self.new(@line),
                             Identifier.new(@line, "define_constructor_class_method:"),
                             MessageArgs.new(@line, method_ident))
        ms.bytecode(g)
      end
    end

    class MethodArgs < Rubinius::AST::FormalArguments
      def initialize(line, *args)
        super(line, args.map(&:to_sym), nil, nil)
      end
    end

  end
end
