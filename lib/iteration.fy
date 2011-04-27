class Fancy {
  class BreakIteration : StdError {
    read_slots: ['return_value]
    def initialize: @return_value {}
  }

  class NextIteration : StdError {
    read_slots: ['return_value]
    def initialize: @return_value {}
  }
}
