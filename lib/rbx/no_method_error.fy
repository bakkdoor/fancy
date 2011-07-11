class NoMethodError {
  """
  Exception class that gets thrown when a method wasn't found within a class.
  """

  def method_name {
    """
    @return Name of the method not found (as @String@).

    Returns the name of the method that was not found as a @String@.
    """

    name to_s match: {
      case: /^:/ -> (name to_s from: 1 to: -1 . to_sym)
      case: _ -> name
    }
  }

  def self inspect {
    "NoMethodError"
  }
}
