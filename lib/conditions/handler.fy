class Conditions {
  class Handler {
    """
    Class that represents Condition handlers.
    """

    read_slot: 'pattern
    def initialize: @pattern with: @block
    def call: args {
      @block call: args
    }
  }
}