class Fancy
  # This version of Fancy::CodeLoader is used only for bootstrapping
  # This constant needs to be overloaded with fancy version of this.
  class CodeLoader

    class << self
      def path
        @path ||= []
      end

      def load_compiled_file(file, find_file = nil)
        path.push(File.expand_path(File.dirname(file), path.last))

        file = File.expand_path(File.basename(file), path.last)

        file = file + "c" if file =~ /.fy$/
        file = file+".fyc" unless file =~ /\.fyc$/
        raise "File not found #{file}" unless File.exist?(file)

        cl = Rubinius::CodeLoader.new(file)
        cm = cl.load_compiled_file(file, 0)

        source = file.sub(/\.fyc/, ".fy")

        script = cm.create_script(false)
        script.file_path = source

        MAIN.__send__ :__script__

        path.pop
      end

      alias_method "require:", :load_compiled_file
    end
  end
end


require File.expand_path("../rbx/fancy_ext", File.dirname(__FILE__))
main = ARGV.shift
lib =  if main.include?(".boot"); "../.boot"; else "../lib"; end
lib =  File.expand_path(lib, File.dirname(__FILE__))
Fancy::CodeLoader.load_compiled_file File.expand_path("boot", lib)
Fancy::CodeLoader.load_compiled_file File.expand_path(main)

