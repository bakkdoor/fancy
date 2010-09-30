#
# Stages for compiling Fancy to Rubinius bytecode.
# 

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
      
    end

    # FancySexp -> FancyAST
    class FancyAST < Stage
      stage :fancy_ast
      next_stage FancyGenerator

      def initialize(compiler, last)
        super
      end

      def run
        @output = Fancy::AST.from_sexp @input
        run_next
      end
    end

    # FancyFile -> FancySexp
    #
    # This stage produces a fancy sexp using ruby literals.
    # 
    class FancyParser < Stage
      stage :fancy_file
      next_stage FancyAST

      def initialize(compiler, last)
        super
        compiler.parser = self
      end

      def input(file, line=1)
        # TODO: fancy parser does not output line information.
        @file = file
      end

      def run
        # Currently we call an external fancy program to output
        # Fancy sexp using ruby literals
        str = `./bin/fancy --rsexp #{@file}`
        sexp = eval(str)
        @output = sexp
        run_next
      end

    end

  end
end
