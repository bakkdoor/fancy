def ARGV for_option: op_name do: block {
  "Runs a given block if an option is in ARGV.";

  ARGV index: op_name . if_do: |idx| {
    block argcount > 0 if_true: {
      ARGV[idx + 1] if_do: |arg| {
        block call: arg
      }
    } else: {
      block call
    }
  }
};

def ARGV for_options: op_names do: block {
  "Runs a given block if any of the given options is in ARGV.";

  done = nil;
  i = 0;
  size = op_names size;
  { done not and: (i < size) } while_true: {
    ARGV index: (op_names[i]) . if_do: |idx| {
      block argcount > 0 if_true: {
        ARGV[idx + 1] if_do: |arg| {
          block call: arg
        }
      } else: {
        block call
      };
      done = true
    };
    i = i + 1
  }
};
