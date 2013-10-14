class Regexp {
  """
  Regular Expression class. Used by Regexp literals in Fancy.
  """

  def Regexp [string] {
    """
    Same as @Regexp#new:@
    """

    new: string
  }

  def call: args {
    args first =~ self
  }

  def matches?: string {
    """
    @string @String@ to match against @self.
    @return @true, if @string matches @self, @false otherwise.
    """

    if: (string =~ self) then: {
      return true
    }
    return false
  }
}
