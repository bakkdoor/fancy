class Console {
  "Console class. Used for @STDIO."

  def Console newline {
    "Prints a newline to @STDOUT."

    STDOUT puts()
  }

  def Console print: obj {
    """
    @obj Object to be printed on @STDOUT.

    Prints a given object on @STDOUT.
    """

    STDOUT print(obj)
  }

  def Console println: obj {
    """
    @obj Object to be printed on @STDOUT, followed by a newline.

    Prints a given object on @STDOUT, followed by a newline.
    """

    STDOUT puts(obj)
  }

  def Console readln: message {

    """
    @message A @String@ that should be printed to @STDOUT before reading from @STDIN.
    @return Line (@String@) read from @STDIN.

    Prints a given message to @STDOUT, followed by reading a line from
    @STDIN.
    """

    Console print: message
    STDIN eof? if_true: {
      nil
    } else: {
      STDIN gets() chomp
    }
  }

  def Console readln {
    """
    @return Line (@String@) read from @STDIN.

    Reads a line from @STDIN and returns it as a @String@.
    """

    STDIN gets() chomp
  }

  def Console clear {
    "Clears the @Console@."

    STDOUT print("\033[H\033[2J")
  }
}
