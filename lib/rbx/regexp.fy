class Regexp {
  ruby_alias: 'inspect
  ruby_alias: 'to_s

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
