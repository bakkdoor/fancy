require 'fileutils'

class Fancy
  class Compiler
    class Command
      def self.option_flag(argv, name)
        argv.delete name
      end

      def self.option_value(argv, name)
        if idx = argv.index(name)
          value = argv.delete_at(idx + 1)
          argv.delete_at(idx)
          value
        end
      end

      def self.run(argv)
        batch = option_flag(argv, "--batch")
        print = option_flag(argv, "-B")
        src_path = option_value(argv, "--source-path")
        out_path = option_value(argv, "--output-path")
        argv.each do |f|
          out = nil
          if out_path && src_path
            out = f.sub(src_path, out_path) + "c"
          end
          compile(f, out, batch, print)
        end
      end

      def self.compile(file, out = nil, info_output = false, print = false)
        puts "Compiling #{file}" if info_output
        FileUtils.mkdir_p(File.dirname(out)) if out
        Compiler.compile_fancy_file file, out, 1, print
      end
    end
  end
end
