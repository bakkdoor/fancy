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
        docstring = @body.shift_docstring
        super(g)
        MethodDef.set_docstring(g, docstring, @line)
      end


      # Sets fancy documentation for the object currently
      # on top of the stack
      def self.set_docstring(g, docstring, line)
        # prevent invoking documentation: when doesnt makes sense.
        return unless docstring
        local = StackLocal.new
        local.set!(g)
        ms = MessageSend.new(line,
                             Fancy::AST::Identifier.new(line, "Fancy::Documentation"),
                             Fancy::AST::Identifier.new(line, "for:is:"),
                             MessageArgs.new(line, local, docstring))
        ms.bytecode(g)
        g.pop
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

    class StackLocal
      def set!(g)
        # expects value to be on top of stack
        @local = g.new_stack_local
        g.set_stack_local @local
      end

      def bytecode(g)
        g.push_stack_local @local
      end
    end

    class MethodArgs < Rubinius::AST::FormalArguments
      def initialize(line, *args)
        super(line, args.map(&:to_sym), nil, nil)
      end
    end

  end
end
