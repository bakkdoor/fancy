class Proxies {
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
    An ActorProxy is a Proxy that forwards any message sent to it to
    it's @target object as a future send by default. If explicitly sent
    an async message, it will forward the async send to @target,
    returning @nil instead of a @FutureSend@, as expected.

    Example:

          ap = ActorProxy new: target_actor

          # this:
          f = ap some_future_send: an_arg
          # is the same as:
          f = target_actor @ some_future_send: an_arg

          # and this:
          ap @@ some_async_send: another_arg
          # is the same as:
          target_actor @@ some_async_send: another_arg
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

  class DistributingProxy : Fancy BasicObject {
    """
    DistributingProxy is a Proxy that round-robin distributes messages to objects
    in a @Fancy::Enumerable@ specified upon creation.

    Example:

          p = DistributingProxy new: [worker1, worker2, worker3, worker4]
          loop: {
            req = @input receive_request
            p handle_request: req         # will be forwarded to worker1-4
          }
    """

    def initialize {
      ArgumentError raise: "Missing list of proxy targets"
    }

    def initialize: @targets {
      @free = @targets to_a dup
      @mutex = Mutex new
      @waiting = ConditionVariable new
    }

    def __with_target__: block {
      t = @mutex synchronize: {
        { @waiting wait: @mutex } until: { @free empty? not }
        @free shift
      }
      val = block call: [t]
      @mutex synchronize: { @free << t; @waiting broadcast }
      val
    }

    instance_methods reject: /^(:initialize|initialize:|__with_target__:|unknown_message:with_params:|send_async:with_params:|send_future:with_params:|__send__)$/ . each: |m| {
      undef_method(m)
    }

    def unknown_message: m with_params: p {
      __with_target__: @{ receive_message: m with_params: p }
    }

    def send_async: m with_params: p {
      __with_target__: @{ send_async: m with_params: p }
    }

    def send_future: m with_params: p {
      __with_target__: @{ send_future: m with_params: p }
    }
  }
}
