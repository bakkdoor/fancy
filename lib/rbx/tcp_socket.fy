require("socket")

class TCPSocket {
  """
  TCP Socket class.
  """

  def TCPSocket open: server port: port {
    """
    @server Server hostname to open Socket on.
    @port Server port to open Socket on.

    Creates and opens a new @TCPSocket@ on @server and @port.
    """

    open(server, port)
  }
}
