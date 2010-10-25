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
    lines join: "\n"
  }

  def writeln: x {
    """
    Writes a given argument as a String followed by a newline into the
    File.
    """

    write: x
    self newline
  }

  def print: x {
    "Same as File#write:."

    write: x
  }

  def println: x {
    "Same as File#writeln:."

    writeln: x
  }
}
