class Regexp {
  """
  Regular Expression class. Used by Regexp literals in Fancy.
  """

  ruby_alias: 'inspect
  ruby_alias: 'to_s

  def === string {
    ruby: 'match args: [string]
  }

  def i {
    Regexp new(source(), true)
  }

  def Regexp new: string {
    new(string)
  }

  def Regexp [string] {
    new(string)
  }
}
