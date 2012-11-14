require("thread")

class Thread {
  """
  Thread class.
  Deals with parallel execution.

  TODO:
  => Still need to add more Fancy-ish wrapper methods and method
     documentation.
  """

  ruby_alias: 'abort_on_exception
  ruby_alias: 'join
  ruby_alias: 'run
  ruby_alias: 'alive?
  ruby_alias: 'exit
  ruby_alias: 'exit!
  ruby_alias: 'kill
#  ruby_alias: 'kill!
  ruby_alias: 'terminate
#  ruby_alias: 'terminate!
  ruby_alias: 'priority
#  ruby_alias: 'safe_level
  ruby_alias: 'status
  ruby_alias: 'stop?
  ruby_alias: 'value
  ruby_alias: 'wakeup

  Thread metaclass ruby_alias: 'abort_on_exception
  Thread metaclass ruby_alias: 'current
  Thread metaclass ruby_alias: 'critical
  Thread metaclass ruby_alias: 'exit
  Thread metaclass ruby_alias: 'list
  Thread metaclass ruby_alias: 'main
  Thread metaclass ruby_alias: 'pass
  Thread metaclass ruby_alias: 'stop

  ruby_alias: 'dynamic_vars
  alias_method: 'dynamic_var: for_ruby: 'get_dynamic_variable
  alias_method: 'set_dynamic_var:to: for_ruby: 'set_dynamic_variable

  alias_method: '[] for_ruby: '[]
  alias_method: '[]: for_ruby: '[]=

  def priority: new_prio {
    priority=(new_prio)
  }

  def raise: exception {
    raise(exception)
  }

  def exclusive: block {
    exclusive(&block)
  }

  def Thread new: block {
    new(&block)
  }

  def Thread abort_on_exception: abort_on_exception {
    abort_on_exception=(abort_on_exception)
  }

  def abort_on_exception: abort_on_exception {
    abort_on_exception=(abort_on_exception)
  }

  def Thread critical: critical {
    critical=(critical)
  }

  def Thread kill: thread {
    kill(thread)
  }

  def Thread start: block {
    start(&block)
  }

  def Thread sleep: seconds {
    "Sets the Fancy process for a given amount of seconds to sleep."

    Kernel sleep(seconds)
  }
}
