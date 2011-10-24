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
    """
    @other Other @Date@ to compare to.
    @return @true if equal, @false otherwhise.
    """

    self == other not
  }
}