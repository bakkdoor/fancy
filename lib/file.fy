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

  def File overwrite: filename with: block {
    """
    @filename Filename of @File@ to overwrite.
    @block @Block@ called with a @File@ object to write to (overwriting old contents.

    Opens a @File@ for writing, overwriting old content.
    """

    File open: filename modes: ['truncate] with: block
  }

  metaclass alias_method: 'truncate:with: for: 'overwrite:with:

  def File append: filename with: block {
    """
    @filename Filename of @File@ to append to.
    @block @Block@ called with a @File@ object to append to.

    Opens a @File@ for appending and calls @block with it.
    """

    File open: filename modes: ['append] with: block
  }

  def File read: filename with: block {
    """
    @filename Filename of @File@ to read from.
    @block @Block@ called with a @File@ object to read from.

    Opens a @File@ for reading and calls @block with it.
    """

    File open: filename modes: ['read] with: block
  }

  def File read_binary: filename with: block {
    """
    @filename Filename of @File@ to read from.
    @block @Block@ called with a @File@ object to read from.

    Opens a @File@ for reading and calls @block with it.
    """

    File open: filename modes: ['read, 'binary] with: block
  }

  def File read_binary: filename {
    """
    @filename Filename of @File@ to read from.
    @return @String@ that is the binary data in @filename.

    Opens and reads the contents of a @File@ in binary mode and
    returns its binary contents as a @String@.
    """

    content = nil
    File read_binary: filename with: |f| {
      content = f read
    }
    content
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

  def File eval: filename {
    """
    @filename Name of Fancy source file (*.fy) to be read and evaluated.
    @return Value of evaluating code in @filename.
    """

    File read: filename . eval
  }

  def File read_config: filename {
    """
    @filename @String@ that is the name of file to be read as a config file.
    @return @Hash@ of key-value pairs of the config file.

    Reads a .fy source file as a config file.

    Example:
          # Given a file config.fy with these contents:
          {
            host: \"127.0.0.1\"
            port: 1234
            names: [
              'foo,
              'bar,
              'baz
            ]
            something_else: {
              another_value: 'foo
            }
          }

          # It can be read like so:
          config = File read_config: \"config.fy\"

          # config is now:
          <[
            'host => \"127.0.0.1\",
            'port => 1234,
            'names => ['foo, 'bar, 'baz],
            'something_else: <[
              'another_value => 'foo
            ]>
          ]>
    """

    File eval: filename . to_hash_deep
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
