class IO {
  ruby_alias: 'readlines
  ruby_alias: 'readline
  ruby_alias: 'read
  ruby_alias: 'close

  def readln {
    self readline
  }

  def println {
    self puts()
  }

  def print: obj {
    self print(obj)
  }

  def println: obj {
    self puts(obj)
  }

  def printchar: char {
    self printc(char)
  }

  alias_method: 'write: for: 'print:
  alias_method: 'writeln: for: 'println:
}
