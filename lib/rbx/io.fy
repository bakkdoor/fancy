class IOMixin {
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

class IO {
  """
  Base class for IO related classes (like @File@, @Socket@, @Console@ etc.).
  """

  include: IOMixin

  ruby_aliases: [ 'readlines, 'readline, 'read, 'close, 'eof? ]

  forwards_unary_ruby_methods
}
