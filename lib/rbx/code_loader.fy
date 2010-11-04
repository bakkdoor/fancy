class Fancy CodeLoader {
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
    push_loadpath(path)
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
