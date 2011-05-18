class File {
  """
  Instances of File represent files in the filesystem of the operating
  system on which Fancy is running.
  """

  # def self exists?: filename {
  #   "Indicates, if a File exists with a given filename."
  #   try {
  #     f = File open: filename modes: ['read]
  #     f close
  #     true
  #   } catch IOError => e {
  #     nil
  #   }
  # }

  def self read: filename {
    """
    Reads all the contens (in ASCII mode) of a given file and returns
    them as an Array of lines being read.
    """

    lines = []
    File open: filename modes: ['read] with: |f| {
      { f eof? } while_false: {
        lines << (f readln)
      }
    }
    lines join
  }

  def self touch: filename {
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
}
