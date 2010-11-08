module Fancy
  module AST

    class Script < Node
      attr_reader :body, :filename
      attr_writer :body

      def initialize(line, filename)
        super(line)
        @filename = filename
      end

      def bytecode(g)
        docs, code = body.expressions.partition { |s| s.kind_of?(Rubinius::AST::StringLiteral) }

        if code.empty?
          # only literal string found, we have to evaluate to it, not
          # use as documentation.
          docs, code = [], docs
        end

        code.each { |c| c.bytecode(g) }

        # the docs array has top-level expressions that are
        # simply string literals, we can use them for file-level
        # documentation.
        # TODO: implement file documentation here.
      end

    end

  end
end
