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

    Prints @message on @\*stderr\* and exits with an exit code of 1 (indicating
    failure).
    """

    *stderr* println: message
    abort
  }

  def System aborting: message do: block {
    """
    @message Message to print on @*stderr* before calling @block and exiting.
    @block @Block@ to be called before exiting execution.

    Prints @message on @\*stderr\*, calls @block and finally exits with an exit
    code of 1 (indicating failure).
    """

    *stderr* println: message
    block call
    abort
  }
}
