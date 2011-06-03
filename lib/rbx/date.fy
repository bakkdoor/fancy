require("date")

class Date {
  """
  Date class. Used for timely stuff.
  """

  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods

  metaclass ruby_alias: 'today
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+
  ruby_alias: '<
  ruby_alias: '>

  def != other {
    self == other not
  }
}