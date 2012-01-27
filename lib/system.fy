class System {
  def System abort {
    """
    Exits the current running Fancy process (application) with an exit
    code of 1 (indicating failure).
    """

    exit: 1
  }

  def System abort: message {
    """
    @message Error message to be printed before aborting programm execution.

    Prints a given message on @*stderr* and then exits with an exit
    code of 1 (indicating failure).
    """

    *stderr* println: message
    abort
  }
}