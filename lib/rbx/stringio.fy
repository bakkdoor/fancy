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
    each_line(&block)
  }
}