Celluloid metaclass tap: @{
  forwards_unary_ruby_methods
  alias_method: 'current_actor for_ruby: 'current_actor
}

class CelluloidExtensions {
  def after: time do: block {
    after(time, &block)
  }

  def defer: block {
    defer(&block)
  }

  def exclusive: block {
    exclusive(&block)
  }

  def receive: block {
    Celluloid receive(nil, &block)
  }

  def receive: timeout do: block {
    Celluloid receive(timeout, &block)
  }
}

Celluloid include: CelluloidExtensions

class ClassMethodsExtensions {
  def trap_exit: method_name {
    trap_exit(message_name: method_name)
  }
}

Celluloid ClassMethods include: ClassMethodsExtensions

class Celluloid ActorProxy {
  forwards_unary_ruby_methods

  def send_future: msg with_params: p {
    future(message_name: msg, *p)
  }

  def send_async: msg with_params: p {
    Celluloid Actor async(@mailbox, message_name: msg, *p)
  }

  def receive_message: msg with_params: p {
    send(msg, *p)
  }
}

class Celluloid Future {
  forwards_unary_ruby_methods
  alias_method: 'signal: for_ruby: 'signal
}