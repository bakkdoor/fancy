class StdError {
  read_slots: ['message]
  def initialize: message {
    @message = message
  }

  def to_s {
    @message to_s
  }
}
