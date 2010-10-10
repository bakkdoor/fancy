module Fancy
  module Compiler
    class Command
      def self.run(argv)
        file = ARGV.first
        raise "Expected filename as single argument." unless file
        puts "Compiling #{file}"
        Rubinius::Compiler.compile_fancy_file file
      end
    end
  end
end
