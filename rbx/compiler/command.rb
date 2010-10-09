module Fancy
  module Compiler
    class Command
      def self.run(argv)
        puts "ARGV IS: #{ARGV.inspect}"
        file = ARGV.first
        opt = Rubinius::Options.new "Fancy Rubinius compiler"
        opt.doc "Usage: fancy.rbc [OPTIONS] source.fnc"
        opt.doc ""
        opt.doc "OPTIONS:"
        opt.help
        argv = opt.parse(argv)
        if argv.empty?
          puts "Expected fancy input file as argument"
          puts "Try --help for usage."
          exit 1
        end
        Rubinius::Compiler.compile_fancy_file file
      end
    end
  end
end
