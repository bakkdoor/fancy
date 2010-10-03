module Fancy
  module AST

    class Identifier < Node
      name :ident

      def initialize(line, identifier)
        super(line)
        @identifier = identifier
      end

      def constant?
        @identifier =~ /^[A-Z]/
      end

      def instance_variable?
        @identifier =~ /^@/
      end

      def local_variable?
        !(constant? || instance_variable?)
      end

      def name
        if constant?
          @identifier.to_sym
        elsif instance_variable?
          @identifier[1..-1].to_sym
        else
          rubyfy(@identifier).to_sym
        end
      end

      def rubyfy(ident)
        ident.split(":").join("__")
      end

      def bytecode(g)
        if constant?
          Rubinius::AST::ConstantAccess.new(line, name).bytecode(g)
        elsif instance_variable?
          Rubinius::AST::InstanceVariableAccess.new(line, name).bytecode(g)
        else
          Rubinius::AST::LocalVariableAccess.new(line, name).bytecode(g)
        end
      end

    end

  end
end
