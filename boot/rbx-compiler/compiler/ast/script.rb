class Fancy
  class AST

    class Script < Node
      attr_reader :body, :filename

      @@stack = []

      def push_script
        @@stack.push self
      end

      def pop_script
        @@stack.pop
      end

      def self.current
        @@stack.last
      end

      def initialize(line, filename, body)
        super(line)
        @filename = filename
        @body = body
      end

      def bytecode(g)
        begin
          push_script

          #docs, code = body.expressions.partition do |s|
          #  s.kind_of?(Rubinius::AST::StringLiteral)
          #end

          #if code.empty?
            # only literal string found, we have to evaluate to it, not
            # use as documentation.
          #  docs, code = [], docs
          #end

          #code.each { |c| c.bytecode(g) }
          @body.bytecode(g)

          # the docs array has top-level expressions that are
          # simply string literals, we can use them for file-level
          # documentation.
          # TODO: implement file documentation here.
        ensure
          pop_script
        end
      end

    end

  end
end
