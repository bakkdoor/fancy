class Regexp {
  def === string {
    ruby: 'match args: [string]
  }

  def i {
    Regexp new(source(), true)
  }
}

class MatchData {
  ruby_alias: '[]
}
