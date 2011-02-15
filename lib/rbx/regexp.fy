class Regexp {
  def === string {
    ruby: 'match args: [string]
  }

  def i {
    Regexp new(self source(), true)
  }
}

class MatchData {
  ruby_alias: '[]
}
