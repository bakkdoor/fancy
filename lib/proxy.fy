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

class RespondsToProxy : BasicObject {
  """
  A RespondsToProxy is a Proxy that forwards any message sent to it to it's @target instance variable
  only if it responds to that message. Any messages that @target doesn't respond to simply won't be sent
  and @nil will be returned.
  """

  def initialize: @target {
  }

  def unknown_message: msg with_params: params {
    if: (@target responds_to?: msg) then: {
      @target send: msg params: params
    }
  }
}