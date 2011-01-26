require: "../number"

class Fixnum {
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
  alias_method: ":%" for: "modulo:" # use a : so we dont overwrite ruby's % operator

}
