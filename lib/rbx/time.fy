class Time {
  """
  Time class. Used for even more timely stuff.
  """

  forwards_unary_ruby_methods

  metaclass ruby_alias: 'now
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+
  ruby_alias: '>
  ruby_alias: '<
  ruby_alias: '>=
  ruby_alias: '<=

  def != other {
    self == other not
  }
}