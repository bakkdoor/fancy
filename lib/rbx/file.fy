class File {
  @@open_mode_conversions =
    <['read => "r",
      'write => "w",
      'append => "a",
      'at_end => "a",
      'binary => "b",
      'truncate => "w+"]>

  ruby_aliases: [ 'eof?, 'closed?, 'flush ]

  forwards_unary_ruby_methods

  def File open: filename modes: modes_arr with: block {
    """
    @filename Filename to open/create.
    @modes_arr Array of symbols that describe the desired operations to perform.
    @block @Block@ that gets called with the @File@ object that has been opened.

    Opens a File with a given @filename, a @modes_arr (@Array@) and a @block.

    E.g. to open a File with read access and read all lines and print them to STDOUT:

        File open: \"foo.txt\" modes: ['read] with: |f| {
          { f eof? } while_false: {
            f readln println
          }
        }
    """

    modes_str = modes_str: modes_arr

    try {
      open(filename, modes_str, &block)
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File exists?: filename {
    """
    @filename Path to file to check for existance.
    @return @true if @File@ exists, @false otherwise.

    Indicates if the @File@ with the given @filename exists.
    """

    File exists?(filename)
  }

  metaclass alias_method: 'expand_path: for_ruby: 'expand_path

  def initialize: path {
    initialize(path)
  }

  def close {
    """
    Closes an opened @File@.
    """

    try {
      close()
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File open: filename modes: modes_arr {
    """
    @filename Filename to open/create.
    @modes_arr Array of symbols that describe the desired operations to perform.
    @return A @File@ instance that represents the opened @File@.

    Similar to open:modes:with: but takes no @Block@ argument to be
    called with the @File@ instance.
    Returns the opened @File@ instead and expects the caller to @close it manually.
    """

    modes_str = modes_str: modes_arr
    f = nil
    try {
      f = open(filename, modes_str)
      f modes: modes_arr
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
    f
  }

  def File modes_str: modes_arr {
    """
    @modes_arr Array of symbols that describe the desired operations to perform.
    @return @String@ that represents the @File@ access modifiers, as used by Ruby.

    Returns the appropriate @String@ representation of the @modes_arr.
    """

    str = ""
    modes_arr each: |m| {
      str << (@@open_mode_conversions[m])
    }
    str uniq join: ""
  }

  def File delete: filename {
    """
    @filename Path to @File@ to be deleted.

    Deletes a @File@ with a given @filename.
    """

    try {
      delete(filename)
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File directory?: path {
    """
    @path Path to check if it's a @Directory@.
    @return @true, if the @path refers to a @Directory@, @false otherwise.

    Indicates, if a given @path refers to a @Directory@.
    """

    directory?(path)
  }

  def File rename: old_name to: new_name {
    """
    @old_name Path to @File@ to rename.
    @new_name Path to new filename.

    Renames a @File@ on the filesystem.
    """

    File rename(old_name, new_name)
  }

  def modes {
    """
    @return @File@ access modes @Array@.

    Returns the @File@ access modes @Array@.
    """

    @modes
  }

  def modes: modes_arr {
    """
    @modes_arr New @File@ access modes @Array@.

    Sets the @File@ access modes @Array@.
    """

    @modes = modes_arr
  }

  def open? {
    """
    @return @true, if @File@ opened, @false otherwise.

    Indicates, if a @File@ is opened.
    """

    closed? not
  }

  def write: str {
    """
    @str String to be written to a @File@.

    Writes a given @String@ to a @File@.
    """

    print(str)
  }

  def read: bytes {
    """
    @bytes Integer the amount of bytes to read from a @File@.
    """

    read(bytes)
  }

  def newline {
    "Writes a newline character to the @File@."

    puts()
  }

  def directory? {
    """
    @return @true, if @File@ is a @Directory@, @false otherwise.

    Indicates, if a @File@ is a @Directory@.
    """

    File directory?(filename)
  }
}
