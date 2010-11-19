class Fancy {
  class CodeLoader {
    """
    Fancy CodeLoader.

    Is used to load Fancy source (.fy) and compiled (.fyc) files into
    the runtime.
    """

    @file_stack = []
    @loaded = <[]>
    @load_path = []
    self metaclass read_slots: ['file_stack, 'loaded, 'load_path]

    def self current_file: compiled_from {
      self file_stack last
    }

    def self source_filename: file {
      match file -> {
        case /.*\.compiled\.fyc$/ -> file from: 0 to: -14
        case /.*\.fyc$/ -> file from: 0 to: -2
        case /\.fy$/ -> file
        case _ -> file
      }
    }

    def self compiled_filename: file {
      match file -> {
        case /\.fyc$/ -> file
        case /\.fy$/ -> file + "c"
        case _ -> file + ".compiled.fyc"
      }
    }

    def self file_not_found: file {
      "File not found: " ++ file . raise!
    }

    def self load_compiled_file: file source: source {
      """
        Loads a rubinius bytecode file:
      """
      { file_not_found: file } unless: $ File file?(file)
      cl = Rubinius CodeLoader new(file)
      cm = cl load_compiled_file(file, 0)
      script = cm create_script(false)
      script file_path=(source)
      MAIN __send__('__script__)
    }

    def self push_loadpath: path {
      """
      @path The path to add to the @LOADPATH

      Adds a given path to Fancy's @LOADPATH.
      """
      { self load_path << path } unless: $ self load_path includes?: path
    }

    def self find: file path: path {
      "Find a file in path. Returns nil if not found."
      found = nil
      path find() |d| {
        abs = File expand_path(file, d)
        File file?(abs) if_do: { found = abs }
        }
      found
    }

    def self load: cmp source: src again: again {
      "Load compiled file @cmp"
      needed = { again } || { self loaded key?(src) not }
      if: needed then: {
        self file_stack push(src)
        self loaded at: src put: cmp
        try {
          load_compiled_file: cmp source: src
        } finally {
          self file_stack pop()
        }
      }
      true
    }

    def self load: abs again: again compile: compile {
      src = abs
      cmp = compiled_filename: src
      File file?(cmp) if_do: { return load: cmp source: src again: again }

      File extname(abs) empty? if_do: {
        src = abs + ".fy"
        cmp = compiled_filename: src
        File file?(cmp) if_do: { return load: cmp source: src again: again }
      }

      compile if_do: {

        src = abs
        cmp = compiled_filename: src
        File file?(abs) if_do: {
           Compiler compile_file: src to: cmp
           return load: cmp source: src again: again
        }

        File extname(abs) empty? if_do: {
          src = abs + ".fy"
          cmp = compiled_filename: src
          File file?(abs) if_do: {
             Compiler compile_file: src to: cmp
             return load: cmp source: src again: again
          }
        }

      }
      nil
    }

    def self load: file again: again find: find compile: compile {
      base = self file_stack last
      base if_do: { base = File dirname(base) }

      dir = File expand_path(File dirname(file), base)
      abs = File expand_path(File basename(file), dir)

      loaded = load: abs again: again compile: compile
      loaded if_do: { return loaded }

      loaded = load: file again: again compile: compile
      loaded if_do: { return loaded }

      find if_do: {
        path = [dir] + $ self load_path
        f = find: file path: path
        f if_do: { return load: f again: again compile: compile }
        f = find: (compiled_filename: file) path: path
        f if_do: { return load: f again: again compile: compile }
        f = find: (source_filename: file) path: path
        f if_do: { return load: f again: again compile: compile }
      }

      file_not_found: file
    }

    def self fancy_load: file {
       load: file again: true  find: true compile: true
    }

    def self fancy_require: file {
       load: file again: false find: true compile: true
    }

    self metaclass send('alias_method, "require:", "fancy_require:")
    self metaclass send('alias_method, "load:", "fancy_load:")
    self metaclass send('alias_method, "load_compiled_file:", "fancy_load:")
    self metaclass send('alias_method, "load_compiled_file", "fancy_load:")
    self metaclass send('alias_method, "push_loadpath", "push_loadpath:")

  }
}
