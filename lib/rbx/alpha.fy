class Object {
  # Let's define false, true, nil & self =)
  dynamic_method(':false) |g| {
    g push_false()
    g ret()
  }

  dynamic_method(':true) |g| {
    g push_true()
    g ret()
  }

  dynamic_method(':nil) |g| {
    g push_nil()
    g ret()
  }
}

class Class {
  def alias_method: new for: old {
    alias_method(new, old)
  }

  def ruby_alias: method_name {
    alias_method(":" + (method_name to_s), method_name)
  }
}

class String {
  alias_method: ":+" for: "+"
}