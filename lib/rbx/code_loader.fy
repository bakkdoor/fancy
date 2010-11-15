class Fancy {
  class CodeLoader {
    """
    Fancy CodeLoader.

    Is used to load Fancy source (.fy) and compiled (.fyc) files into
    the runtime.
    """

    SOURCE_FILE_EXTENSION = "fy"
    COMPILED_FILE_EXTENSION = "fyc"

    def self load_path {
      """
      @return An @Array@ with all the paths in the @LOADPATH.
      """

      @@load_path
    }

    def self push_loadpath: path {
      """
      @path The path to add to the @LOADPATH

      Adds a given path to Fancy's @LOADPATH.
      """
      { @@load_path << path } unless: $ @@load_path includes?: path
    }

    # Throws an exception for a given filename that wasn't found and
    # thus could not be loaded.
    def self load_error: filename {
      "LoadError: Can't find file: " ++ filename raise!
    }

    # Returns the name of a file or nil, if it doesn't exist.
    # Might append a ".fy" extension, if it's missing for the given
    # filename.
    def self find_file: filename {
      filename_with_ext = filename ++ "." ++ SOURCE_FILE_EXTENSION
      { File exists?(filename) } || { File directory?(filename) } if_do: {
        { return filename_with_ext } if: $ File exists?(filename_with_ext)
      } else: {
        return filename
      }
      nil
    }


    # Finds a file in a given path and returns the filename including
    # the path.
    def self find_file: file in_path: path {
      find_file: (path + "/" + file)
    }

    # Tries to find a file with a given name in the LOADPATH array
    # (all paths that have been seen while loading other files so
    # far), starting with the @current_dir (the directory, the current
    # running fancy source file is in).
    def self filename_for: filename {
      find_file: filename . if_do: |f| {
        return f
      } else: {
        @@current_dir last if_do: {
          find_file: filename in_path: (@@current_dir last) . if_do: |f| {
            return f
          }
        }
        @@load_path each: |p| {
          try {
            find_file: filename in_path: p . if_do: |f| {
              return f
            }
          } catch {
          }
        }
      }
      load_error: filename
    }

    # Returns the source filename for a given filename.
    # E.g. "foo.fyc" => "foo.fy"
    def self source_filename_for: filename {
      regexp = Regexp new(".compiled." ++ COMPILED_FILE_EXTENSION ++ "$")
      filename =~ regexp . if_do: {
        return filename from: 0 to: -14
      } else: {
        regexp = Regexp new("." ++ COMPILED_FILE_EXTENSION ++ "$")
        filename =~ regexp if_do: {
          return filename from: 0 to: -2
        }
      }
      filename
    }


    # Returns the compiled filename for a given filename.
    # E.g. "foo.fy" => "foo.fyc", "foo" => "foo.compiled.rbc"
    def self compiled_filename_for: filename {
      filename =~ (Regexp new("." + COMPILED_FILE_EXTENSION + "$")) if_do: {
        return filename
      }
      filename =~ (Regexp new("." + SOURCE_FILE_EXTENSION + "$")) if_do: {
        return filename + "c"
      } else: {
        return filename + ".compiled." + COMPILED_FILE_EXTENSION
      }
    }

    # Optionally compiles a file, if not done yet and returns the
    # compiled file's name.
    def self optionally_compile_file: f {
      source_filename = source_filename_for: f
      filename = filename_for: source_filename
      compiled_file = compiled_filename_for: filename
      @@compiled[filename] true? if_false: {
        { File exists?(compiled_file) not } || \
            { File stat(compiled_file) mtime() < (File stat(filename) mtime()) } if_do: {
          Compiler compile_fancy_file(filename, nil, 1, false)
        } else: {
          @@compiled at: filename put: true
        }
      }
      compiled_file
    }


    # Loads a compiled fancy bytecode file.
    # If +find_file+ is set to false, it will just use the given
    # filename without looking up the file in the LOADPATH.
    def self load_compiled_file: filename find_file: find_file (true) {
      find_file if_do: {
        filename = filename_for: filename
        file = compiled_filename_for: filename
      }

      file = optionally_compile_file: file

      @@loaded[file] true? if_false: {
        File exists?(file) if_false: {
          load_error: file
        }

        dirname = File dirname(file)
        push_loadpath: dirname
        @@current_dir push(dirname)
        @@loaded at: file put: true

        cl = Rubinius::CodeLoader new(file)
        cm = cl load_compiled_file(file, 0)

        script = cm create_script(false)
        script file_path=(filename)

        MAIN __send__('__script__)

        @@current_dir pop()
      }
    }


    def self load_compiled_file: file {
      """
      @file The .fy file to be loaded (and possible compiled first).

      Loads (and optionally compiles it first, if not already done so) a
      given .fy source file into the runtime.
      """

      load_compiled_file(file)
    }
  }
}
