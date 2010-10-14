module Rubinius

  class Compiler

    def self.fancy_compiled_name(file)
      if file.suffix? ".fy"
        file + "c"
      else
        file + ".compiled.rbc"
      end
    end

    # Writes the compiled output file
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

    # Returns a compiled method to be loaded by the rbx runtime.
    def self.compile_fancy_code(code, filename = "(eval)", line = 1, print = false)
      compiler = new :fancy_code, :compiled_method

      parser = compiler.parser
      parser.root AST::Script
      parser.input code, filename, line

      if print
        parser.print true
        printer = compiler.packager.print
        printer.bytecode = true
      end

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{filename}", e
      end
    end

    # Returns a compiled method to be evaled by the rbx runtime.
    def self.compile_fancy_eval(code, variable_scope, filename = "(eval)", line = 1, print = false)
      compiler = new :fancy_code, :compiled_method

      parser = compiler.parser
      parser.root AST::EvalExpression
      parser.input code, filename, line

      if print
        parser.print = true
        printer = compiler.packager.print
        printer.bytecode = true
      end

      compiler.generator.variable_scope = variable_scope

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{filename}", e
      end
    end

  end

end
