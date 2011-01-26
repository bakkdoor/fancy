class Bignum {
  include: Number

  ruby_alias: '==
  ruby_alias: '-
  ruby_alias: '+
  ruby_alias: '*
  ruby_alias: '/
  ruby_alias: '<
  ruby_alias: '>
  ruby_alias: '<=
  ruby_alias: '>=
  ruby_alias: '===
  ruby_alias: 'chr
  ruby_alias: 'to_i
  ruby_alias: '**
  ruby_alias: '&

  alias_method: 'to_s: for: 'to_s
  alias_method: 'modulo: for: 'modulo
  # prepend with : so we dont overwrite ruby's % operator
  alias_method: ":%" for: "modulo:"

}
