class System {
  def System abort: message {
    """
    @message Error message to be printed before aborting programm execution.

    Prints a given message on @*stderr* and then exits with a exit
    code of 1 (indicating failure).
    """

    *stderr* println: message
    exit: 1
  }
}