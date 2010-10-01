module Rubinius

  class Compiler

    def self.compile_fancy_file(file, output = nil, line = 1, transforms = :fancy)
      compiler = new :fancy_file, :compiled_file

      parser = compiler.parser
      parser.root AST::Script

      if transforms.kind_of? Array
        transforms.each { |t| parser.enable_category t }
      else
        parser.enable_category transforms
      end

      parser.input file, line
      parser.print

      writer = compiler.writer
      writer.name = output ? output : compiled_name(file)

      begin
        compiler.run
      rescue Exception => e
        compiler_error "Error trying to compile fancy: #{file}", e
      end
    end

  end

end
