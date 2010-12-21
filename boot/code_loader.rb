#!/usr/bin/env rbx

base = File.dirname(__FILE__) + "/"

# load in fancy specific extensions
require base + "fancy_ext"

require base + "/rbx-compiler/compiler"
require base + "/rbx-compiler/compiler/command"

# only used for bin/fdoc at the moment
# this is just temporary and was copied from and old version
# of rbx/fancy_code_loader.rb

class Fancy
  class CodeLoader
    class << self
      SOURCE_FILE_EXTENSION = "fy"
      COMPILED_FILE_EXTENSION = "fyc"

      @@load_path = []
      @@compiled = {}
      @@loaded = {}
      @@current_dir = []

      def push_loadpath path
        @@load_path << path unless @@load_path.include? path
      end

      # Throws an exception for a given filename that wasn't found and
      # thus could not be loaded.
      def load_error(filename)
        raise "LoadError: Can't find file: #{filename}"
      end

      # Returns the name of a file or nil, if it doesn't exist.
      # Might append a ".fy" extension, if it's missing for the given
      # filename.
      def find_file(filename)
        filename_with_ext = filename + ".#{SOURCE_FILE_EXTENSION}"
        if !File.exists?(filename) || File.directory?(filename)
          return filename_with_ext if File.exists? filename_with_ext
        else
          return filename
        end
        nil
      end

      # Finds a file in a given path and returns the filename including
      # the path.
      def find_file_in_path(file, path)
        find_file(path + "/" + file)
      end

      # Tries to find a file with a given name in the LOADPATH array
      # (all paths that have been seen while loading other files so
      # far), starting with the @current_dir (the directory, the current
      # running fancy source file is in).
      def filename_for(filename)
        if f = find_file(filename)
          return f
        else
          if @@current_dir.last && f = find_file_in_path(filename, @@current_dir.last)
            return f
          end
          @@load_path.each do |p|
            begin
              if f = find_file_in_path(filename, p)
                return f
              end
            rescue
            end
          end
        end
        load_error filename
      end

      # Returns the source filename for a given filename.
      # E.g. "foo.fyc" => "foo.fy"
      def source_filename_for(filename)
        if filename =~ /.compiled.#{COMPILED_FILE_EXTENSION}$/
          return filename[0..-14]
        elsif filename =~ /.#{COMPILED_FILE_EXTENSION}$/
          return filename[0..-2]
        end
        filename
      end

      # Returns the compiled filename for a given filename.
      # E.g. "foo.fy" => "foo.fyc", "foo" => "foo.compiled.rbc"
      def compiled_filename_for(filename)
        if filename =~ /.#{COMPILED_FILE_EXTENSION}$/
          return filename
        end
        if filename =~ /\.#{SOURCE_FILE_EXTENSION}$/
          return filename + "c"
        else
          return filename + ".compiled.#{COMPILED_FILE_EXTENSION}"
        end
      end

      # Optionally compiles a file, if not done yet and returns the
      # compiled file's name.
      def optionally_compile_file(f)
        source_filename = source_filename_for(f)
        filename = filename_for(source_filename)
        compiled_file = compiled_filename_for(filename)
        unless @@compiled[filename]
          if !File.exists?(compiled_file) ||
            File.stat(compiled_file).mtime < File.stat(filename).mtime
            Compiler.compile_fancy_file filename, nil, 1, false
          else
            @@compiled[filename] = true
          end
        end
        compiled_file
      end

      # Loads a compiled fancy bytecode file.
      # If +find_file+ is set to false, it will just use the given
      # filename without looking up the file in the LOADPATH.
      def load_compiled_file(filename, find_file = true)
        if find_file
          filename = filename_for(filename)
          file = compiled_filename_for(filename)
        end

        file = optionally_compile_file(file)

        unless @@loaded[file]
          unless File.exists? file
            load_error file
          end

          dirname = File.dirname(file)
          push_loadpath dirname
          @@current_dir.push dirname
          @@loaded[file] = true

          cl = Rubinius::CodeLoader.new(file)
          cm = cl.load_compiled_file(file, 0)

          script = cm.create_script(false)
          script.file_path = filename

          MAIN.__send__ :__script__

          @@current_dir.pop
        end
      end
      alias_method "require:", :load_compiled_file
    end
  end
end

if $0 == __FILE__
  # load & run file
  file = ARGV.shift
  raise "Expected a fancy file to load" unless file
  if File.exists? file
    Fancy::CodeLoader.load_compiled_file file
  else
    Fancy::CodeLoader.load_compiled_file(base + "../lib/main.fyc")
  end
end
