class IO {
  """
  Base class for IO related classes (like @File@, @Socket@, @Console@ etc.).
  """

  ruby_alias: 'readlines
  ruby_alias: 'readline
  ruby_alias: 'read
  ruby_alias: 'close
  ruby_alias: 'eof?

  def readln {
    readline
  }

  def println {
    puts()
  }

  def print: obj {
    print(obj)
  }

  def println: obj {
    puts(obj)
  }

  def printchar: char {
    printc(char)
  }

  alias_method: 'write: for: 'print:
  alias_method: 'writeln: for: 'println:
}
