class Console {
  "Console class. Used for stdio."

  def Console newline {
    "Prints a newline to stdout."

    STDOUT puts()
  }

  def Console print: obj {
    "Prints a given object on STDOUT."

    STDOUT print(obj)
  }

  def Console println: obj {
    "Prints a given object on STDOUT, followed by a newline."

    STDOUT puts(obj)
  }

  def Console readln: message {
    "Prints a given message to stdout, followed by reading a line from stdin."

    Console print: message
    STDIN eof? if_true: {
      nil
    } else: {
      STDIN gets() chomp()
    }
  }

  def Console readln {
    "Reads a line from STDIN and returns it as a String."

    STDIN gets() chomp()
  }

  def Console clear {
    "Clears the console."

    STDOUT print("\033[H\033[2J")
  }
}
