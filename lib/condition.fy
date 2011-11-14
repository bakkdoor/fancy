class Condition {
  def signal! {
    *condition_system* handle: self
  }
}

class Error : Condition

class Object {
  def restarts: restarts in: block {
    let: '*restarts* be: (restarts to_hash) in: block
  }

  def handlers: handlers_block in: block {
    ch = ConditionHandler new
    let: '*condition_system* be: ch in: {
      handlers_block call: [ch]
      block call
    }
  }

  def invoke_restart: restart {
    *restarts*[restart] call
  }
}

class ConditionHandler {
  def initialize {
    @handlers = Stack new
  }

  def when: pattern do: handler {
    @handlers push: (pattern, handler)
  }

  def handle: condition {
    @handlers each: |h| {
      pattern, handler = h
      match condition {
        case pattern -> return handler call: [condition]
      }
    }
  }
}