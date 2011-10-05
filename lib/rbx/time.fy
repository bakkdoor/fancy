class Time {
  """
  Time class. Used for even more timely stuff.
  """

  forwards_unary_ruby_methods

  metaclass ruby_alias: 'now
  ruby_aliases: [ '==, '-, '+, '<, '>, '<=, '>= ]

  def != other {
    self == other not
  }
}