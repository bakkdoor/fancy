class Fancy
  # This version of Fancy::CodeLoader is used only for bootstrapping
  # This constant needs to be overloaded with fancy version of this.
  class BootstrapCodeLoader

    class << self
      def path_stack
        @path_stack ||= []
      end

      def file_stack
        @file_stack ||= []
      end

      # This method may return an Fancy::Script object with source
      # information.
      def current_file(compiled_from)
        # compiled_from is the filename captured at compile time.
        # ie. the location where the fancy file was compiled from.

        # file_stack.last is the filename being loaded
        # possibly from a different location than it was compiled from

        # Only return the current file being loaded.
        file_stack.last
      end
      alias_method "current_file:", :current_file

      def load_compiled_file(file, find_file = nil)
        path_stack.push(File.expand_path(File.dirname(file), path_stack.last))

        file = File.expand_path(File.basename(file), path_stack.last)

        file = file + "c" if file =~ /.fy$/
        file = file+".fyc" unless file =~ /\.fyc$/
        raise "File not found #{file}" unless File.exist?(file)

        cl = Rubinius::CodeLoader.new(file)
        cm = cl.load_compiled_file(file, 0)

        source = file.sub(/\.fyc/, ".fy")

        file_stack.push(source)

        script = cm.create_script(false)
        script.file_path = source

        MAIN.__send__ :__script__

        file_stack.pop
        path_stack.pop
      end

      alias_method "require:", :load_compiled_file
    end
  end

  CodeLoader = BootstrapCodeLoader
end


require File.expand_path("../rbx/fancy_ext", File.dirname(__FILE__))
main = ARGV.shift
lib =  if main.include?(".boot"); "../.boot"; else "../lib"; end
lib =  File.expand_path(lib, File.dirname(__FILE__))
Fancy::CodeLoader.load_compiled_file File.expand_path("boot", lib)
Fancy::CodeLoader.load_compiled_file File.expand_path(main)

