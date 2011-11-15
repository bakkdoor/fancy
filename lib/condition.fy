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
  def restarts: restarts in: block {
    let: '*restarts* be: (*restarts* merge: (restarts to_hash)) in: block
  }

  def handlers: handlers_block in: block {
    ch = ConditionHandler new: *condition_handler*
    let: '*condition_handler* be: ch in: {
      handlers_block call: [ch]
      block call
    }
  }

  def restart: restart {
    if: (*restarts*[restart]) then: |r| {
      *handled* = true
      r call
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
    restarts: {
      quit_application: {
        *stderr* println: "Quitting."
        System exit: 1
      }
    } in: {
      with_output_to: *stderr* do: {
        "Unhandled condition: #{condition}" println
        "Available restarts:" println
        *restarts* keys each_with_index: |r i| {
          "(#{i}) #{r}" println
        }

        "Choose a restart:" println
        idx = *stdin* readln to_i
        if: (*restarts* keys[idx]) then: |r| {
          restart: r
        } else: {
          handle: condition
        }
      }
    }
  }
}

*condition_handler* = DebuggerConditionHandler new