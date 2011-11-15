class Condition {
  """
  Base Condition class.
  All Conditions should inherit from this.
  """

  def signal! {
    """
    Signals @self to the condition system.
    The first matching dynamically bound condition handler will be called.
    If no condition handler matching @self is found, the default Debugger will be invoked.

    Example:
          class ZeroDivError : Error # Error is a subclass of Condition
          class Fixnum {
            def divide_by: other {
              if: (other == 0) then: {
                ZeroDivError new raise! # raise ZeroDivError condition
              } else: {
                self / other
              }
            }
          }
    """

    *condition_manager* handle: self
  }
}

class Error : Condition
Error documentation: "Base class for all error conditions."

class ConditionSystem {
  class UnhandledCondition : Error {
    """
    Gets signaled if a condition wasn't handled.
    """

    read_slot: 'condition
    def initialize: @condition
  }

  class UndefinedRestart : Error {
    """
    Gets signaled if a restart to be called isn't defined.
    """

    read_slot: 'restart
    def initialize: @restart
  }


  class ConditionHandler {
    """
    Class that represents Condition handlers.
    """

    read_slot: 'pattern
    def initialize: @pattern with: @block
    def call: args {
      @block call: args
    }
  }

  class ConditionManager {
    """
    Manager for @ConditionSystem::ConditionHandler@s.
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

      @handlers push: $ ConditionHandler new: pattern with: handler_block
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
      @parent handle: $ UnhandledCondition new: condition
    }
  }

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

# Object extensions
class Object {
  def with_restarts: restarts do: block {
    """
    @restarts @Block@ / @Hash@ of restart names to callables (@Symbol@ => @Block@).
    @block @Block@ in which @restarts will be bound.

    Defines (dynamically binds) restarts within @block.

    Example:
          with_restarts: {
            quit_application: { \"Quitting\" println; System exit: 0 }
            use_default: { @default_value } # defined somewhere
          } do: {
            # do something that might signal a condition
          }
    """

    let: '*restarts* be: (*restarts* merge: (restarts to_hash)) in: block
  }

  def with_handlers: handlers_block do: block {
    """
    @handlers_block @Block@ called with an instance of @ConditionManager@ to define condition handlers.
    @block @Block@ in which the condition handlers defined in @handler_block will be bound.

    Calls @block with condition handlers defined in @handlers_block bound.

    Example:
          with_handlers: @{
            when: SomeCondition do: |c| { # c is bound to the Condition
              restart: 'some_restart with_params: (1,2,3)
            }
          } do: {
            # do something that might signal a condition
          }
    """

    cm = ConditionSystem ConditionManager new: *condition_manager* # link to parent
    let: '*condition_manager* be: cm in: {
      handlers_block call: [cm]
      block call
    }
  }

  def restart: restart with_params: params ([]) {
    """
    @restart @Symbol@ that is the name of the restart.
    @params @FancyEnumerable@ of parameters passed to the restart's @Block@.
    @return Return value of invoking @restart.

    Calls the @Block@ associated with @restart, if available, and returns its value.
    If @restart is not defined, this will cause a @UndefinedRestart@ condition to be signaled.
    """

    if: (*restarts*[restart]) then: |r| {
      *handled* = true
      r call: params
    } else: {
      UndefinedRestart new: restart . signal!
    }
  }

  def find_restart: restart {
    """
    @restart @Symbol@ that is the name of the restart.
    @return @Block@ that is the handler of @restart, or @nil, if @restart is not defined.
    """

    *restarts*[restart]
  }
}

# vars
*restarts* = <[]>
*restarts* documentation: "@Hash@ of currently available restarts (dynamically bound)."
*debugger* = ConditionSystem DefaultDebugger new
*debugger* documentation: "Condition debugger. Defaults to @ConditionSystem::DefaultDebugger@."
*condition_manager* = ConditionSystem ConditionManager new: *debugger*  # default
*condition_manager* documentation: "Instance of @ConditionSystem::ConditionManager@. Used to define @ConditionSystem::ConditionHandler@s."