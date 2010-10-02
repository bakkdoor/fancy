module Fancy
  module AST

    class MethodDef < Rubinius::AST::Define
      include Rubinius::Compiler::LocalVariables
      Nodes[:method_def] = self

      def initialize(line, method_ident, args, body)
        @line = line
        @name = method_ident.name.to_sym
        @arguments = args
        @body = body
      end
    end

    class MethodArgs < Rubinius::AST::FormalArguments
      Nodes[:args] = self
      def initialize(line, *args)
        super(line, args.map(&:to_sym), nil, nil)
      end
    end

  end
end
