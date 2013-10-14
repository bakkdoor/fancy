ARGV documentation: """
  ARGV is a singleton instance of @Array@ and holds all (command-line)
  arguments passed to a Fancy programm before it starts executing.
  """

def ARGV for_option: option_name do: block {
  """
  @option_name Name of command-line option.
  @block @Block@ to be called with value of command-line option @option_name, if given.
  @return @true, if @option_name was found in @ARGV and @block was called, @false otherwise.

  Calls a given Block if a command-line option is in @ARGV.
  """

  if: (ARGV index: option_name) then: |idx| {
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
  return false
}

def ARGV for_options: option_names do: block {
  """
  @option_names @Fancy::Enumerable@ of related command-line option names.
  @block @Block@ to be called with value of any command-line option in @option_names, if given.
  @return @true, if any of @option_names was found in @ARGV and @block was called, @false otherwise.

  Calls a given Block if any of the given command-line options are in @ARGV.
  """

  option_names each: |option_name| {
    if: (ARGV for_option: option_name do: block) then: {
      return true
    }
  }
  return false
}