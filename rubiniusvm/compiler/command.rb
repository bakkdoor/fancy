module Fancy
  module Compiler
    class Command
      def self.run(argv)
        raise "Expected fancy input file as argument" if argv.empty?
        file = argv.first
        Rubinius::Compiler.compile_fancy_file file
      end
    end
  end
end
