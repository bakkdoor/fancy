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
  ruby_alias: '<=>
  ruby_alias: '**
}
