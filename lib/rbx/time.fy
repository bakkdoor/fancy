class Time {
  metaclass ruby_alias: 'now
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+

  def != other {
    self == other not
  }
}