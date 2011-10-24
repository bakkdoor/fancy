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

  def m {
    Regexp new(source(), Regexp MULTILINE)
  }

  def x {
    Regexp new(source(), Regexp EXTENDED)
  }

  def Regexp new: string {
    new(string)
  }

  def Regexp [string] {
    new(string)
  }
}
