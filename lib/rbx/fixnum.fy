require: "../number"

class Fixnum {
  """
  Standard class for integer values in Fancy.
  """

  include: Number

  ruby_aliases: [
    '==, '-, '+, '*, '/, '<, '>, '<=, '>=,
    '===, 'chr, 'to_i, 'to_f, '**, '&, '|
  ]

  alias_method: 'to_s: for: 'to_s
  alias_method: 'modulo: for: 'modulo
  alias_method: ":%" for: "modulo:" # use a : so we dont overwrite ruby's % operator
  alias_method: 'div: for: 'div
}
