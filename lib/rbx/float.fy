class Float {
  """
  Standard class for floating point number values in Fancy.
  """

  include: Number

  forwards_unary_ruby_methods

  ruby_alias: '+
  ruby_alias: '-
  ruby_alias: '*
  ruby_alias: '/
  ruby_alias: '==
  ruby_alias: '>=
  ruby_alias: '<=
  ruby_alias: '**
  ruby_alias: '<
  ruby_alias: '>

  alias_method: 'modulo: for: 'modulo
  alias_method: ":%" for: "modulo:" # use a : so we dont overwrite ruby's % operator
}
