class Conditions {
  class DefaultDebugger {
    """
    Default Debugger class that comes with Fancy.
    When asked to handle an unhandled condition,
    let's the user pick a restart in the console.
    """

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
}