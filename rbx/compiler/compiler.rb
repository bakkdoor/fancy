module Rubinius

  class Compiler

    def self.fancy_compiled_name(file)
      if file.suffix? ".fy"
        file + "c"
      else
        file + ".compiled.rbc"
      end
    end

    def self.compile_fancy_file(file, output = nil, line = 1, print = false)
      compiler = new :fancy_file, :compiled_file

      parser = compiler.parser
      parser.root AST::Script

      parser.input file, line

      if print
        printer = compiler.packager.print
        printer.bytecode = true
      end

      writer = compiler.writer
      writer.name = output ? output : fancy_compiled_name(file)

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{file}", e
      end
    end

    # => this is somewhat a hack, need to fix this
    # I haven't looked very much into how exactly the compiler class
    # deals with the stages etc., so I added a getter for the @start
    # stage instance var of Rubinius::Compiler, since this is where we
    # start for now. We should probably go write a seperate Stage
    # class for the new parser... I feel bad :(
    class Rubinius::Compiler
      attr_reader :start
    end

    def self.compile_fancy_file_from_ast(file, ast_root, output = nil, line = 1, print = false)
      compiler = new :fancy_bytecode, :compiled_file

      gen = compiler.start
      gen.input ast_root

      if print
        printer = compiler.packager.print
        printer.bytecode = true
      end

      writer = compiler.writer
      writer.name = output ? output : fancy_compiled_name(file)

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{file}", e
      end
    end

  end

end
