module Fancy
  module AST

    class MethodDef < Rubinius::AST::Define
      Nodes[:method_def] = self

      def initialize(line, method_ident, args, body)
        @line = line
        # this is a hack
        # we really should be able to define 'initialize:' methods but
        # rbx will only look for 'initialize' methods when calling 'new'
        # on a class.
        if method_ident.name == :"initialize:"
          @name = :initialize
        else
          @name = method_ident.name.to_sym
        end
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
