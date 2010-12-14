#
# Stages for compiling Fancy to Rubinius bytecode.
#

class Fancy
  class Compiler

    # FancyAST -> Rubinius Symbolic bytecode
    class FancyGenerator < Rubinius::Compiler::Stage
      stage :fancy_bytecode
      next_stage Rubinius::Compiler::Encoder

      attr_accessor :variable_scope

      def initialize(compiler, last)
        super
        @variable_scope = nil
        compiler.generator = self
      end

      def run
        @output = Rubinius::Generator.new
        @input.variable_scope = @variable_scope
        @input.bytecode @output
        @output.close
        run_next
      end

      def input(root_ast)
        @input = root_ast
      end
    end

    # Fancy string -> AST
    class FancyCodeParser < Rubinius::Compiler::Stage
      stage :fancy_code
      next_stage FancyGenerator

      def initialize(compiler, last)
        super
        compiler.parser = self
      end

      def root(root)
        @root = root
      end

      def print
        @print = true
      end

      def input(code, filename="(eval)", line=1)
        @input = code
        @filename = filename
        @line = line
      end

      def run
        ast = Parser.parse_string(@input, @line, @filename)
        @output = @root.new ast
        @output.file = @filename
        run_next
      end
    end

    # Fancy file -> AST
    class FancyFileParser < Rubinius::Compiler::Stage
      stage :fancy_file
      next_stage FancyGenerator

      def initialize(compiler, last)
        super
        compiler.parser = self
      end

      def root(root)
        @root = root
      end

      def print
        @print = true
      end

      def input(filename, line=1)
        @filename = filename
        @line = line
      end

      def run
        ast = Parser.parse_file(@filename, @line)
        # p ast if @print
        @output = @root.new ast
        @output.file = @filename
        run_next
      end
    end

  end
end
