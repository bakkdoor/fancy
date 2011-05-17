require("actor")

class Actor {
  alias_method(':!, '<<)

  metaclass ruby_alias: 'receive
  metaclass ruby_alias: 'current

  def Actor spawn: block {
    Actor spawn(&block)
  }
}
