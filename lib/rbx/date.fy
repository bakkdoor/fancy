require("date")

class Date {
  """
  Date class. Used for timely stuff.
  """

  forwards_unary_ruby_methods
  metaclass forwards_unary_ruby_methods

  metaclass ruby_alias: 'today
  ruby_aliases: [ '==, '-, '+, '<, '> ]

  def != other {
    self == other not
  }
}