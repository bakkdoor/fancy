module Rubinius

  class Compiler

    def self.compile_fancy_file(file, line = 1)
      compiler = new :fancy_file, :compiled_file
      compiler.parser.input file, line
      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{file}", e
      end
    end

  end

end
