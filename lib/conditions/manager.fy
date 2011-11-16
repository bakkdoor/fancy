class Conditions {
  class Manager {
    """
    Manager for @Conditions::Handler@s.
    Used to define conditions and their handlers.
    """

    def initialize: @parent {
      @handlers = Stack new
    }

    def when: pattern do: handler_block {
      """
      @pattern Pattern to use to match a signaled condition.
      @handler_block Handler @Block@ to be invoked if @pattern matches a signaled condition.

      Registers a handler for a condition.

      Example:
            with_handlers: @{
              # define condition handlers:
              when: SomeCondition do: |c| {
                # do something with c or invoke a restart
              }
              # you can use anything as the pattern, including Regexes:
              when: /foo/ do: |c| {
              }
            } do: {
              # do something
            }
      """

      @handlers push: $ Handler new: pattern with: handler_block
    }

    def handle: condition {
      """
      @condition Condition to be handled by @self.

      Goes through the current list of condition handlers and invokes the first one who's pattern matches @condition (using the @=== operator).
      If no handler matches, lets the Debugger handle @condition.
      """

      let: '*handled* be: false in: {
        @handlers each: |h| {
          match condition {
            case h pattern ->
              val = h call: [condition]
              { return val } if: *handled*
          }
        }
      }
      # condition not handled, use debugger
      @parent handle: condition
    }
  }
}