class Bignum {
  """
  Class for large integer values in Fancy.
  """

  include: Number

  ruby_aliases: [ '==, '-, '+, '*, '/, '<, '>, '<=, '>=, '===, '**, '& ]

  forwards_unary_ruby_methods

  alias_method: 'to_s: for: 'to_s
  alias_method: 'modulo: for: 'modulo
  alias_method: ":%" for: "modulo:"  # prepend with : so we dont overwrite ruby's % operator
  alias_method: 'div: for: 'div
}
