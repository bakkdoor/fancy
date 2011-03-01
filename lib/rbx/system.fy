class System {
  def System exit {
    "Exit the running Fancy process."

    Kernel exit()
  }

  def System do: command_str {
    "Runs the given string as a system() command."

    Kernel system(command_str)
  }

  def System piperead: command_str {
    """
    Runs the given string as a popen() call and returns the output
    of the call as a string.
    """

    pipe: command_str . readlines map: 'chomp
  }

  def System pipe: command_str {
    """
    Runs the given string as a popen() call and returns a IO handle
    that can be read from
    """

    IO popen(command_str)
  }
}
