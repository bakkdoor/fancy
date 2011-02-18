class ProxyReceiver : BasicObject {
  """
  A ProxyReceiver is an object which proxies all message sends to it to 2 other objects.
  It will send each message first to its @proxy instance variable and then to the @obj instance variable.
  """

  def initialize: @proxy for: @obj {
  }

  def unknown_message: msg with_params: params {
    @proxy send: msg params: params
    @obj send: msg params: params
  }
}

Proxy = ProxyReceiver