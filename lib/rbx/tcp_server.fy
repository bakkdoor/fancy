class TCPServer {
  """
  TCP Server
  """

  ruby_alias: 'accept

  def TCPServer new: host port: port {
    new(host, port)
  }
}
