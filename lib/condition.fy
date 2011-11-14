*restarts* = <[]>

class Condition {
  def signal! {
    *condition_handler* handle: self
  }
}

class Error : Condition

class UnhandledCondition : Error {
  read_slot: 'condition
  def initialize: @condition
}

class Object {
  def restarts: restarts in: block {
    let: '*restarts* be: (*restarts* merge: (restarts to_hash)) in: block
  }

  def handlers: handlers_block in: block {
    ch = ConditionHandler new
    let: '*condition_handler* be: ch in: {
      handlers_block call: [ch]
      block call
    }
  }

  def invoke_restart: restart {
    *handled* = true
    *restarts*[restart] call
  }

  def find_restart: restart {
    *restarts*[restart]
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
    let: '*handled* be: false in: {
      @handlers each: |h| {
        pattern, handler = h
        match condition {
          case pattern ->
            val = handler call: [condition]
            { return val } if: *handled*
        }
      }
    }
    UnhandledCondition new: condition . signal!
  }
}

