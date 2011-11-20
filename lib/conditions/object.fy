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

    try {
      return let: '*restarts* be: (*restarts* merge: (restarts to_hash)) in: block
    } catch Exception => e {
      return e signal!
    }
  }

  def with_handlers: handlers_block do: block {
    """
    @handlers_block @Block@ called with an instance of @Manager@ to define condition handlers.
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

    try {
      cm = Conditions Manager new: *condition_manager* # link to parent
      return let: '*condition_manager* be: cm in: {
        handlers_block call: [cm]
        block call
      }
    } catch Exception => e {
      return e signal!
    }
  }

  def restart: restart with: params ([]) {
    """
    @restart @Symbol@ that is the name of the restart.
    @params @FancyEnumerable@ of parameters passed to the restart's @Block@.
    @return Return value of invoking @restart.

    Calls the @Block@ associated with @restart, if available, and returns its value.
    If @restart is not defined, this will cause a @UndefinedRestart@ condition to be signaled.
    """

    if: (*restarts*[restart]) then: |r| {
      *handled* = true
      r call: $ params to_a
    } else: {
      Conditions UndefinedRestart new: restart . signal!
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
