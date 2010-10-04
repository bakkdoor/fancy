def class DivisionByZeroError : StdError {
  def initialize {
    super initialize: "Division by zero!"
  }
}
