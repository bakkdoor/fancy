module Fancy
  module Compiler
    class Command
      def self.run(argv)
        if ARGV.first == "--old"
          # Using the old c++ parser, outputing rsexp
          parser = :fancy_file_rsexp
          ARGV.shift
        else
          # Using the new ruby_ext parser.
          parser = :fancy_file
        end
        file = ARGV.shift
        raise "Expected filename as single argument." unless file
        puts "Compiling #{file}"
        Rubinius::Compiler.compile_fancy_file file, nil, 1, ARGV.include?("-B"), parser
      end
    end
  end
end
