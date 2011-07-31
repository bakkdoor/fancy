require("open3")

class System {
  """
  System class. Holds system-wide relevant methods.
  """

  def System exit {
    """
    Exit the running Fancy process.
    """

    Kernel exit()
  }

  def System exit: exitcode {
    """
    @exitcode Exit code (Fixnum) to be returned to the parent process.

    Exit the running Fancy process with a given exit code.
    """

    Kernel exit(exitcode)
  }

  def System do: command_str {
    """
    Runs the given string as a system() command.
    """

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
    @command_str String to run as a command via popen3()
    @return @IO@ object representing the command's @STDOUT IO stream.

    Runs the given string as a popen3() call and returns a IO handle
    that can be read from
    """

    in, out, err = Open3 popen3(command_str)
    return out
  }

  def System pipe: command_str do: block {
    """
    @command_str String to run as a command via popen3()
    @block @Block@ to be called with @STDIN, @STDOUT and @STDERR.

    Runs the given string as a popen3() call, passing in a given @Block@.
    The @Block@ is expected to take 3 arguments for @STDIN, @STDOUT and @STDERR.
    """

    Open3 popen3(command_str, &block)
  }
}
