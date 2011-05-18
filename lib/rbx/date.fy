require("date")

class Date {
  """
  Date class. Used for timely stuff.
  """

  metaclass ruby_alias: 'today
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+

  def != other {
    self == other not
  }
}