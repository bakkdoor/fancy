require("rubinius/debugger")

class Rubinius Debugger {
  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods
}

class Rubinius Debugger Command SetBreakPoint {
  def match_method: method_identifier {
    match method_identifier {
      case /##/ ->
        class_name, method_name = method_identifier split: "##"
        method_identifier = "#{class_name}::#{method_name message_name}"
      case /#/ ->
        class_name, method_name = method_identifier split: "#"
        method_identifier = "#{class_name}##{method_name message_name}"
    }

    /([A-Z]\w*(?:::[A-Z]\w*)*)([.#]|::)([a-zA-Z0-9_\[\]:]+[!?=]?)(?:[:](\d+))?/ match: method_identifier
  }

  alias_method('match_method, 'match_method:)
}

class Rubinius Location {
  forwards_unary_ruby_methods
}

class Rubinius Debugger Frame {
  forwards_unary_ruby_methods

  def describe {
    arg_str = ""
    recv = nil
    loc = @location

    if: (loc is_block) then: {
      if: (method required_args == 0) then: {
        recv = "{ } in #{loc describe_receiver}#{loc name}"
      } else: {
        block_args = method local_names join: ", "
        recv = "|#{block_args}| { } in #{loc describe_receiver}#{loc name}"
      }
    } else: {
      recv = loc describe
    }

    recv = recv replace: "#:" with: "#"
    recv = recv replace: ".:" with: "##"
    recv = recv replace: "." with: "##"

    str = "#{recv} at #{loc method active_path}:#{loc line} (#{loc ip})"
    { str << " (+#{loc ip})" } if: $ @debugger variables['show_ip]
    str
  }

  alias_method('describe, ':describe)

  def run: code {
    Fancy eval: (code to_s) binding: binding
  }

  alias_method('run, 'run:)
}

Rubinius Debugger start