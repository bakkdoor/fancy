class File {
  """
  Instances of File represent files in the filesystem of the operating
  system on which Fancy is running.
  """

  def File write: filename with: block {
    """
    @filename Filename of @File@ to write to.
    @block @Block@ called with a @File@ object to write to.

    Opens a @File@ for writing and calls @block with it.
    """

    File open: filename modes: ['write] with: block
  }

  def File read: filename with: block {
    """
    @filename Filename of @File@ to read from.
    @block @Block@ called with a @File@ object to read from.

    Opens a @File@ for reading and calls @block with it.
    """

    File open: filename modes: ['read] with: block
  }

  def File touch: filename {
    """
    @filename Name of @File@ to be created, if not already existant.

    Creates a new empty file with the given @filename, if it doesn't already exist.
    """

    file = File expand_path(filename)
    File open: file modes: ['write] with: |f| {
      f write: ""
    }
  }

  def writeln: x {
    """
    Writes a given argument as a String followed by a newline into the
    File.
    """

    write: x
    newline
  }

  alias_method: 'print: for: 'write:
  alias_method: 'println: for: 'writeln:

  def expanded_path {
    """
    @return Expanded (absolute) path of @self.

    Example:
          f = File open: \"README.txt\"
          f expanded_path # => \"/path/to/README.txt\" (when run from /path/to/)
    """

    File expand_path: path
  }
}
