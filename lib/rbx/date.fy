require("date")

class Date {
  metaclass ruby_alias: 'today
  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+

  def != other {
    self == other not
  }
}