class Directory {
  def self create: dirname {
    """
    @dirname Path of @Directory@ to create.

    Creates a new @Directory@ on the filesystem, possibly throwing
    IOError Exceptions that might occur.
    """

    try {
      Dir mkdir(dirname)
    } catch Errno::EEXIST => e {
      IOError new: (e message) . raise!
    }
  }

  def self create!: dirname {
    """
    @dirname Path of @Directory@ to create.

    Creates a new @Directory@ on the filesystem, ignoring any
    Exceptions that might occur.
    Basically works like running `mkdir -p` on the shell.
    """

    try {
      create: dirname
    } catch IOError {
    }
  }


  def self delete: dirname {
    """
    @dirname Path to @Directory@ to delete.

    Deletes a directory with a given name, if it's empty.
    """

    try {
      Dir delete(dirname)
    } catch StandardError => e {
      IOError new: (e message) . raise!
    }
  }

  def self list: pattern {
    """
    @pattern Directory pattern or name containing files to be returned as an @Array@.
    @return @Array@ of files matching directory @pattern.

    Example usage:
        Directory list: \"tests/**/*.fy\"  # => [\"tests/file1.fy\", \"tests/more/file2.fy\"]
    """

    match pattern {
      case /\/$/ -> pattern = pattern + "*"
      case "." -> pattern = pattern + "/*"
      case ".." -> pattern = pattern + "/*"
    }

    Dir glob(pattern)
  }
}
