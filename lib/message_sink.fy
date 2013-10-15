class Fancy {
  class MessageSink : Fancy BasicObject {
    """
    A MessageSink just swallows all messages that are sent to it.
    """

    def unknown_message: m with_params: p {
      """
      @m Message sent to @self.
      @p @Array@ of parameters sent along with @m.
      @return @self.

      Catches all messages and arguments and simply always returns @self.
      """

      self
    }
  }
}
