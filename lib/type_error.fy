class TypeError : StdError {
  read_slots: ['expected_type, 'actual_type]
  def initialize: msg {
    super initialize: msg
  }

  def initialize: msg expected: expected_type got: actual_type {
    self initialize: msg
    @expected_type = expected_type
    @actual_type = actual_type
  }
}
