require: "conditions/condition"
require: "conditions/debugger"
require: "conditions/handler"
require: "conditions/manager"
require: "conditions/object"
require: "conditions/vars"

class Conditions {
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
}
