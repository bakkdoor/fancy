class Fancy {

  class Compiler : Rubinius Compiler {

    read_write_slots: ['parser, 'generator, 'packager, 'writer]

    def self compiled_name: file {
      file.suffix?(".fy") if_do: {
        file + "c"
      } else: {
        file + ".compiled.fyc"
      }
    }

    def self from: first_stage to: last_stage {
      new(first_stage, last_stage)
    }

    def self compile_file: file to: output (nil) line: line (1) print: print (false) {
      compiler = from: 'fancy_file to: 'compiled_file
      parser = compiler parser
      parser root: Rubinius AST Script
      parser input: file line: line
      print if_do: {
        parser print: true
        printer = compiler packager print()
        printer bytecode=(true)
      }
      writer = compiler writer
      writer name=(output if_do: { output } else: { compiled_name: file })
      try {
        compiler run()
      } catch Exception => e {
        compiler_error("Error trying to compile " ++ file, e)
      }
    }

  }

}
