class Time {
  """
  Time class. Used for even more timely stuff.
  """


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