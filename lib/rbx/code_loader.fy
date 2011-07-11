class Fancy {
  class CodeLoader {
    """
    Fancy CodeLoader.

    Is used to load Fancy source (.fy) and compiled (.fyc) files into
    the runtime.
    """

    SOURCE_FILE_EXTENSION = "fy"
    COMPILED_FILE_EXTENSION = "fyc"

    @@load_path = []
    @@loaded = <[]>
    @@compiled = <[]>
    @@file_stack = []
    @@current_dir = []

    def self file_stack {
      @@file_stack
    }

    def self loaded {
      @@loaded
    }

    def self load_path {
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
      filename_with_ext = filename + "." + SOURCE_FILE_EXTENSION
      if: ({File exists?(filename) not} || {File directory?(filename)}) then: {
        { return filename_with_ext } if: $ File exists?(filename_with_ext)
      } else: {
        return filename
      }
      nil
    }

    # Finds a file in a given path and returns the filename including
    # the path.
    def self find_file: file in_path: path {
      find_file: $ path + "/" + file
    }


    # Tries to find a file with a given name in the LOADPATH array
    # (all paths that have been seen while loading other files so
    # far), starting with the @current_dir (the directory, the current
    # running fancy source file is in).
    def self filename_for: filename {
      if: (find_file: filename) then: |f| {
        return f
      } else: {
        if: (@@current_dir last) then: {
          if: (find_file: filename in_path: (@@current_dir last)) then: |f| {
            return f
          }
        }
        @@load_path each: |p| {
          try {
            if: (find_file: filename in_path: p) then: |f| {
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
    def self source_filename_for: file {
      file match: {
        case: /.*\.compiled\.fyc$/ do: (file from: 0 to: -14)
        case: /.*\.fyc$/ do: (file from: 0 to: -2)
        case: /\.fy$/ do: file
        else: file
      }
    }

    # Returns the compiled filename for a given filename.
    # E.g. "foo.fy" => "foo.fyc", "foo" => "foo.compiled.fyc"
    def self compiled_filename_for: file {
      file match: {
        case: /\.fyc$/ do: file
        case: /\.fy$/ do: (file + "c")
        else: (file + ".compiled.fyc")
      }
    }

    # Optionally compiles a file, if not done yet and returns the
    # compiled file's name.
    def self optionally_compile_file: f {
      source_filename = source_filename_for: f
      filename = filename_for: source_filename
      compiled_file = compiled_filename_for: filename
      unless: (@@compiled[filename]) do: {
        if: ({File exists?(compiled_file) not} || \
             {File stat(compiled_file) mtime() <((File stat(filename) mtime()))}) then: {
          # Rubinius::Compiler.compile_fancy_file filename, nil, 1, false
          Compiler compile_file: filename to: compiled_file
        } else: {
          @@compiled[filename]: true
        }
      }
      compiled_file
    }


    # Loads a compiled fancy bytecode file.
    # If +find_file+ is set to false, it will just use the given
    # filename without looking up the file in the LOADPATH.
    def self load_compiled_file: source_file find_file: find_file (true) {
      compiled_file = source_file

      if: find_file then: {
        source_file = filename_for: source_file

        dir = File expand_path(File dirname(source_file), ".")
        source_file = File expand_path(File basename(source_file), dir)

        compiled_file = compiled_filename_for: source_file
      }

      compiled_file = optionally_compile_file: compiled_file

      unless: (@@loaded[compiled_file]) do: {
        unless: (File exists?(compiled_file)) do: {
          load_error: compiled_file
        }

        dirname = File dirname(compiled_file)
        push_loadpath: dirname
        @@current_dir push(dirname)
        @@loaded[compiled_file]: true

        cl = Rubinius::CodeLoader new(compiled_file)
        cm = cl load_compiled_file(compiled_file, 0)

        script = cm create_script(false)
        script file_path=(source_file)


        try {
          @@file_stack push(source_file)
          MAIN __send__('__script__)
        } finally {
          @@current_dir pop()
          @@file_stack pop()
        }
      }
    }

    def self current_file: compiled_from {
      @@file_stack last
    }

    def self file_not_found: file {
      "File not found: " ++ file . raise!
    }

    def self fancy_require: file {
       load_compiled_file: file find_file: true
    }

    metaclass send('alias_method, "require:", "fancy_require:")
    metaclass send('alias_method, "load:", "load_compiled_file:")
    metaclass send('alias_method, "load_compiled_file", "load_compiled_file:")
    metaclass send('alias_method, "push_loadpath", "push_loadpath:")
  }
}
