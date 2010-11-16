class Fancy Compiler Stages {

  class Stage : Rubinius Compiler Stage {

    initialize = |compiler, last| {
      sup = Rubinius Compiler Stage instance_method('initialize)
      sup bind(self) call(compiler, last)
      initialize: compiler last: last
    }
    define_method('initialize, &initialize)

    def self stage: name next: next (nil) {
      stage(name)
      next_stage(next)
    }

    run = { self run; run_next() }
    define_method('run, &run)

  }

  class FancyGenerator : Stage {

    stage: 'fancy_bytecode next: Rubinius Compiler Encoder

    read_write_slots: ['variable_scope]

    def initialize: compiler last: last {
      @variable_scope = nil
      compiler generator: self
    }

    def run {
      @output = Rubinius Generator new()
      @input variable_scope=(@variable_scope)
      @input bytecode(@output)
      @output close()
    }

  }

  class FancyCodeParser : Stage {
    stage: 'fancy_code next: FancyGenerator
    read_write_slots: ['root, 'print]

    def initialize: compiler last: last {
      compiler parser: self
    }

    def input: @code file: @filename line: @line (1) {}

    def run {
      ast = Fancy Parser parse_code: @code file: @filename line: @line
      @print if_do: { ast inspect println }
      @output = @root new(ast)
      @output file=(@filename)
    }
  }

  class FancyFileParser : Stage {

    stage: 'fancy_file next: FancyGenerator
    read_write_slots: ['root, 'print]

    def initialize: compiler last: last {
      compiler parser: self
    }

    def input: @filename line: @line (1) {}

    def run {
      ast = Fancy Parser parse_file: @filename line: @line
      @print if_do: { ast inspect println }
      @output = @root new(ast)
      @output file=(@filename)
    }

  }

}

