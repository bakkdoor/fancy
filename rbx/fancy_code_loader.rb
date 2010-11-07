require File.dirname(__FILE__) + "/compiler"
require File.dirname(__FILE__) + "/compiler/command"

module Fancy
  class CodeLoader
    SOURCE_FILE_EXTENSION = "fy"
    COMPILED_FILE_EXTENSION = "fyc"

    @@load_path = []
    @@compiled = {}
    @@loaded = {}
    @@current_dir = []

    def self.push_loadpath path
      @@load_path << path unless @@load_path.include? path
    end

    # Throws an exception for a given filename that wasn't found and
    # thus could not be loaded.
    def self.load_error(filename)
      raise "LoadError: Can't find file: #{filename}"
    end

    # Returns the name of a file or nil, if it doesn't exist.
    # Might append a ".fy" extension, if it's missing for the given
    # filename.
    def self.find_file(filename)
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
    def self.find_file_in_path(file, path)
      find_file(path + "/" + file)
    end

    # Tries to find a file with a given name in the LOADPATH array
    # (all paths that have been seen while loading other files so
    # far), starting with the @current_dir (the directory, the current
    # running fancy source file is in).
    def self.filename_for(filename)
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
    def self.source_filename_for(filename)
      if filename =~ /.compiled.#{COMPILED_FILE_EXTENSION}$/
        return filename[0..-14]
      elsif filename =~ /.#{COMPILED_FILE_EXTENSION}$/
        return filename[0..-2]
      end
      filename
    end

    # Returns the compiled filename for a given filename.
    # E.g. "foo.fy" => "foo.fyc", "foo" => "foo.compiled.rbc"
    def self.compiled_filename_for(filename)
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
    def self.optionally_compile_file(f)
      source_filename = source_filename_for(f)
      filename = filename_for(source_filename)
      compiled_file = compiled_filename_for(filename)
      unless @@compiled[filename]
        if !File.exists?(compiled_file) ||
            File.stat(compiled_file).mtime < File.stat(filename).mtime
          Rubinius::Compiler.compile_fancy_file filename, nil, 1, false
        else
          @@compiled[filename] = true
        end
      end
      compiled_file
    end

    # Loads a compiled fancy bytecode file.
    # If +find_file+ is set to false, it will just use the given
    # filename without looking up the file in the LOADPATH.
    def self.load_compiled_file(filename, find_file = true)
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
  end
end
