class DateTime {
  # """
  # DateTime class. Used for yet more timely stuff.
  # """

  forwards_unary_ruby_methods

  metaclass alias_method: 'parse: for_ruby: 'parse

  metaclass ruby_alias: 'now
  ruby_aliases: [ '==, '-, '+, '<, '>, '<=, '>= ]

  def != other {
    self == other not
  }
}