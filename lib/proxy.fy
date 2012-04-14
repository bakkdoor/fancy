class ProxyReceiver : Fancy BasicObject {
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

    @proxy receive_message: msg with_params: params
    @obj receive_message: msg with_params: params
  }
}

Proxy = ProxyReceiver

class RespondsToProxy : Fancy BasicObject {
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
      @target receive_message: msg with_params: params
    }
  }
}

class ActorProxy : Fancy BasicObject {
  """
  A ActorProxy is a Proxy that forwards any message sent to it to it's
  @target instance variable as a future send by default.
  If explicitly sent an async message, it will forward the async send
  to @target, returning nil instead of a @FutureSend@, as expected.
  """

  def initialize: @target

  def send_future: m with_params: p {
    @target send_future: m with_params: p
  }

  def send_async: m with_params: p {
    @target send_async: m with_params: p
  }

  def unknown_message: m with_params: p {
    @target send_future: m with_params: p
  }
}