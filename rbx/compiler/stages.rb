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

    # FancySexp -> FancyAST
    class FancyAST < Parser
      stage :fancy_ast
      next_stage FancyGenerator

      attr_accessor :file

      def initialize(compiler, last)
        super
        @processor = nil
      end

      def default_transforms
        @transforms.concat AST::Transforms.category(:fancy)
      end

      def parse
        Fancy::AST.from_sexp @input
      end
    end

    # FancyFile -> FancySexp
    #
    # This stage produces a fancy sexp using ruby literals.
    #
    class FancyParser < Stage
      stage :fancy_file
      next_stage FancyAST

      extend Forwardable

      def initialize(compiler, last)
        super
        compiler.parser = self
      end

      def input(file, line=1)
        # TODO: fancy parser does not output line information.
        @next_stage.file = file
      end

      def_delegators :@next_stage, :root, :enable_category, :print

      def run
        # Currently we call an external fancy program to output
        # Fancy sexp using ruby literals
        str = `./bin/fancy --rsexp #{@next_stage.file}`
        sexp = eval(str)
        @output = sexp
        run_next
      end

    end

  end
end
