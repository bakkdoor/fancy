def class Console {
  "Console class. Used for stdio."

  def Console newline {
    "Prints a newline to stdout."

    Kernel puts
  }

  def Console print: obj {
    "Prints a given object on STDOUT."

    Kernel print: obj
  }

  def Console println: obj {
    "Prints a given object on STDOUT, followed by a newline."

    Kernel puts: obj
  }

  def Console readln: message {
    "Prints a given message to stdout, followed by reading a line from stdin."

    Kernel print: message
    Kernel readln chomp
  }

  def Console readln {
    "Reads a line from STDIN and returns it as a String."

    Kernel readln chomp
  }

  def Console clear {
    "Clears the console."

    Kernel print: "\033[H\033[2J"
  }
}
