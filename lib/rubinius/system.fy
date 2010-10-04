def class System {
  def System exit {
    "Exit the running Fancy process."

    Kernel exit
  }

  def System do: command_str {
    "Runs the given string as a system() command."

    Kernel system: command_str
  }

  def System pipe: command_str {
    """
    Runs the given string as a popen() call and returns the output
    of the call as a string.
    """

    IO popen: command_str . readlines
  }

  def System sleep: n_ms {
    "Sets the Fancy process for a given amount of milliseconds to sleep."

    Kernel sleep: $ n_ms / 1000
  }
}
