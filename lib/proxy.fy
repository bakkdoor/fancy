class ProxyReceiver : BasicObject {
  """
  A ProxyReceiver is an object which proxies all message sends to it to 2 other objects.
  It will send each message first to its @proxy instance variable and then to the @obj instance variable.
  """

  def initialize: @proxy for: @obj {
    """
    @proxy Proxy receiver for @obj.
    @obj Original receiver object.

    Initializes a new ProxyReceiver with @proxy for @obj.
    """

    self
  }

  def unknown_message: msg with_params: params {
    """
    @msg Incoming message name.
    @params Paremeters of incoming message send.

    Forwards all incoming messages to @self to @@proxy and then @@obj.
    """

    @proxy send_message: msg with_params: params
    @obj send_message: msg with_params: params
  }
}

Proxy = ProxyReceiver

class RespondsToProxy : BasicObject {
  """
  A RespondsToProxy is a Proxy that forwards any message sent to it to it's @target instance variable
  only if it responds to that message. Any messages that @target doesn't respond to simply won't be sent
  and @nil will be returned.
  """

  def initialize: @target {
    """
    @target Target receiver object.

    Initializes a new RespondsToProxy for @target.
    """

    self
  }

  def unknown_message: msg with_params: params {
    """
    @msg Incoming message name.
    @params Paremeters of incoming message send.

    Forwards all incoming message to @self to @@target
    only if @@target responds to them.
    """

    if: (@target responds_to?: msg) then: {
      @target send_message: msg with_params: params
    }
  }
}