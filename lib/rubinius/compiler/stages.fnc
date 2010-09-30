def class Rubinius {
  def class Compiler {

    def class Stage {
      @Stages = <[ ]>;

      def self register: stage as: name next: next {
        creator = |compiler last| {
          st = stage new
          st name: name
          st compiler: compiler
          st next: $ create_next_stage: next with: compiler until: last
        }
        @Stages at: name put: creator
      }

      def self from: first to: last with: compiler {
        creator = @Stages at: first
        unless: creator do: { "No such stage `" ++ first ++"'" println; return }
        creator call: [compiler, last]
      }

      def self create_next_stage: next with: compiler until: last {
        (next nil?) || (last nil?) . if_false: {
          Stage from: next to: last with: compiler
        }
      }

      read_write_slots: ['name, 'next, 'input]

      def run {
        @output = self process
        self run_next
      }

      def run_next {
        @next if_do: {
          @next input: @output
          @next run
        } else: {
          @output
        }
      }

      def compiler: compiler {
        # Register self with the compiler chain.
        # Let each stage override this.
      }

    }

    # AST -> symbolic bytecode
    def class Generator : Stage {

      Stage register: self as: 'fancy_ast next: nil
      read_write_slots: ['variable_scope]

      def compiler: compiler {
        compiler generator: self
      }

      def process {
        g = Generator new
        @input bytecode: g  
      }
    }

    # sexp -> AST
    def class FancySexp : Stage {
      Stage register: self as: 'fancy_sexp next: 'fancy_ast
      def process {
        @input to_ast
      }
    }

    def class Parser : Stage {

      def compiler: compiler {
        compiler parser: self
      }

      def process {
        self parse
      }

    }

    # File -> Sexp
    def class File : Parser {
      Stage register: self as: 'file next: 'fancy_sexp

      def input: filename line: line {
        @file = filename
        @line = line  # TODO: The ast doesn't provide line number information.
      }

      def parse {
        exp = System pipe: ("bin/fancy " ++ @file ++ " --sexp")
        exp first eval
      }
    }

    # String -> Sexp
    def class Code : Parser {

       Stage register: self as: 'string next: 'fancy_sexp

       # TODO: implement this.
    }

  }
}
