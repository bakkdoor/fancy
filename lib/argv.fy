def ARGV for_option: op_name do: block {
  "Runs a given block if an option is in ARGV."

  ARGV index: op_name . if_do: |idx| {
    block argcount > 0 if_true: {
      ARGV[idx + 1] if_do: |arg| {
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
    ARGV index: (op_names[i]) . if_do: |idx| {
      block argcount > 0 if_true: {
        ARGV[idx + 1] if_do: |arg| {
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
