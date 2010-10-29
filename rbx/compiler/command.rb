module Fancy
  module Compiler
    class Command
      def self.run(argv)
        if argv.first == "--batch"
          argv.shift
          argv.each do |f|
            do_compile f, true
          end
        else
          file = ARGV.shift
          raise "Expected filename as single argument." unless file
          do_compile file
        end
      end

      def self.do_compile(file, info_output = false)
        puts "Compiling #{file}" if info_output
        Rubinius::Compiler.compile_fancy_file file, nil, 1, ARGV.include?("-B")
      end
    end
  end
end
