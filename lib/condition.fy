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

class UndefinedRestart : Error {
  read_slot: 'restart
  def initialize: @restart
}

class Object {
  def with_restarts: restarts do: block {
    let: '*restarts* be: (*restarts* merge: (restarts to_hash)) in: block
  }

  def with_handlers: handlers_block do: block {
    ch = ConditionHandler new: *condition_handler*
    let: '*condition_handler* be: ch in: {
      handlers_block call: [ch]
      block call
    }
  }

  def restart: restart with_params: params ([]) {
    if: (*restarts*[restart]) then: |r| {
      *handled* = true
      r call: params
    } else: {
      UndefinedRestart new: restart . signal!
    }
  }

  def find_restart: restart {
    *restarts*[restart]
  }
}

class ConditionHandler {
  def initialize: @parent {
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
    unless: *handled* do: {
      @parent handle: $ UnhandledCondition new: condition
    }
  }
}

class DebuggerConditionHandler : ConditionHandler {
  def initialize {
    initialize: nil
  }

  def handle: condition {
    with_output_to: *stderr* do: {
      "" println
      "-" * 50 println
      "Unhandled condition: #{condition}" println

      if: (*restarts* empty?) then: {
        "No restarts available. Quitting." println
        System exit: 1
      }

      "Available restarts:" println
      *restarts* keys each_with_index: |r i| {
        "   " print
        "#{i} -> #{r}" println
      }

      "Restart: " print
      idx = *stdin* readln to_i
      "-" * 50 println
      "" println
      if: (*restarts* keys[idx]) then: |r| {
        restart: r
      } else: {
        handle: condition
      }
    }
  }
}

*condition_handler* = DebuggerConditionHandler new