require("stringio")

class StringIO {
  include: IOMixin
  forwards_unary_ruby_methods
  StringIO forwards_unary_ruby_methods

  ruby_alias: '<<

  def each: block {
    each(&block)
  }

  def each_line: block {
    """
    @block @Block@ to be called with each line in @self.
    """

    each_line(&block)
  }

  def string: str {
    """
    @str @String@ to set @string in @self to.
    """

    string=(str)
  }
}
