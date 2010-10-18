#
# Stages for compiling Fancy to Rubinius bytecode.
#
require 'forwardable'

module Rubinius
  class Compiler

    # FancyAST -> Rubinius Symbolic bytecode
    class FancyGenerator < Stage
      stage :fancy_bytecode
      next_stage Encoder

      def initialize(compiler, last)
        super
      end

      def run
        @output = Rubinius::Generator.new
        @input.bytecode @output
        @output.close
        run_next
      end

      def input(root_ast)
        @input = root_ast
      end
    end

    # Fancy string -> AST
    class FancyCodeParser < Stage
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
        ast = Fancy::Parser.parse_string(@input, @line)
        @output = @root.new ast
        @output.file = @filename
        run_next
      end
    end

    # Fancy file -> AST
    class FancyFileParser < Stage
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
        ast = Fancy::Parser.parse_file(@filename, @line)
        @output = @root.new ast
        @output.file = @filename
        run_next
      end
    end

  end
end
