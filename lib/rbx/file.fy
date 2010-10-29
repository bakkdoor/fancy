class File {
  @@open_mode_conversions =
    <['read => "r",
      'write => "w",
      'append => "+",
      'at_end => "a",
      'binary => "b",
      'truncate => "w+"]>

  ruby_alias: 'eof?
  #ruby_alias: 'close
  ruby_alias: 'closed?

  def File open: filename modes: modes_arr with: block {
    # """
    # Opens a File with a given filename, a modes Array and a block.
    # E.g. to open a File with read access and read all lines and print them to STDOUT:
    # File open: \"foo.txt\" modes: [:read] with: |f| {
    #   { f eof? } while_false: {
    #     f readln println
    #   }
    # }
    # """

    modes_str = modes_str: modes_arr

    try {
      open(filename, modes_str, &block)
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File exists?: filename {
    "Indicates if the file with given filename exists."
    File exists?(filename)
  }

  def close{
    try {
      close()
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File open: filename modes: modes_arr {
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
    str = ""
    modes_arr each: |m| {
      str = str ++ (@@open_mode_conversions[m])
    }
    str uniq join: ""
  }

  def File delete: filename {
    try {
      delete(filename)
    } catch Errno::ENOENT => e {
      IOError new: (e message) . raise!
    }
  }

  def File directory?: path {
    directory?(path)
  }

  def File rename: old_name to: new_name {
    File rename(old_name, new_name)
  }

  def modes {
    @modes
  }

  def modes: modes_arr {
    @modes = modes_arr
  }

  def open? {
    self closed? not
  }

  def write: str {
    print(str)
  }

  def newline {
    puts()
  }

  def directory? {
    File directory?(self filename)
  }
}
