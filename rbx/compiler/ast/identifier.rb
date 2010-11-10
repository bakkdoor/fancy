module Fancy
  module AST

    class Identifier < Node
      attr_reader :identifier

      def initialize(line, identifier)
        super(line)
        @identifier = identifier
      end

      def constant?
        @identifier =~ /^[A-Z]/
      end

      def instance_variable?
        @identifier =~ /^@/ && !class_variable?
      end

      def class_variable?
        @identifier =~ /^@@/
      end

      def local_variable?
        !(constant? || instance_variable? || class_variable?)
      end

      def nested_classname?
        constant? && @identifier.include?("::")
      end

      def true?
        @identifier == "true"
      end

      def false?
        @identifier == "false"
      end

      def nil?
        @identifier == "nil"
      end

      def operator?
        @identifier !~ /^\w/
      end

      def name
        if constant?
          @identifier.to_sym
        elsif class_variable?
          @identifier.to_sym
        elsif instance_variable?
          @identifier.to_sym
        else
          @identifier.to_sym
        end
      end

      def method_name(receiver = nil, with_ruby_args = false)
        if with_ruby_args
          rubyfied.to_sym
        elsif @identifier !~ /:$/
          # methods not ending with ':' have ':' prepended instead.
          # so we dont create colissions with existing ruby methods.
          # if we dont do this, whenever a ruby library tries to
          # invoke (say, the print method) it will find the
          # fancy version (not expecting arguments) and will fail.
          ":#{@identifier}".to_sym
        else
          @identifier.to_sym
        end
      end

      def rubyfied
        if @identifier.split(":").size > 1
          @identifier
        else
          if @identifier =~ /:$/
            @identifier[0..-2]
          else
            @identifier[0..-1]
          end
        end
      end

      def bytecode(g)
        if "__FILE__" == @identifier
          Rubinius::AST::StringLiteral.new(line, Fancy::AST::Script.current.filename).
            bytecode(g)
        elsif nested_classname?
          classnames = @identifier.split("::")
          parent = Identifier.new(@line, classnames.shift)
          classnames.each do |cn|
            Rubinius::AST::ScopedConstant.new(@line, parent, cn.to_sym).bytecode(g)
            child = Identifier.new(@line, cn)
            parent = child
          end
        elsif constant?
          Rubinius::AST::ConstantAccess.new(line, name).bytecode(g)
        elsif class_variable?
          Rubinius::AST::ClassVariableAccess.new(line, name).bytecode(g)
        elsif instance_variable?
          Rubinius::AST::InstanceVariableAccess.new(line, name).bytecode(g)
        elsif true?
          g.push_true
        elsif false?
          g.push_false
        elsif nil?
          g.push_nil
        else
          Rubinius::AST::LocalVariableAccess.new(line, name).bytecode(g)
        end
      end
    end

  end
end
