ARGV documentation: """
  ARGV is a singleton instance of @Array@ and holds all (command-line)
  arguments passed to a Fancy programm before it starts executing.
  """

def ARGV for_option: op_name do: block {
  "Runs a given block if an option is in ARGV."

  ARGV index: op_name . if_true: |idx| {
    if: (block arity > 0) then: {
      ARGV[idx + 1] if_true: |arg| {
        block call: [arg]
        ARGV remove_at: idx
        ARGV remove_at: idx
      }
    } else: {
      block call
      ARGV remove_at: idx
    }
  }
}

def ARGV for_options: op_names do: block {
  "Runs a given block if any of the given options is in ARGV."

  op_names size times: |i| {
    if: (ARGV index: (op_names[i])) then: |idx| {
      if: (block arity > 0) then: {
        if: (ARGV[idx + 1]) then: |arg| {
          block call: [arg]
          ARGV remove_at: idx
          ARGV remove_at: idx
        }
      } else: {
        block call
        ARGV remove_at: idx
      }
      return true
    }
  }
}
