class Object {
  # Let's define false, true & nil =)
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

  def ruby_aliases: method_names {
    method_names each() |m| {
      ruby_alias: m
    }
  }
}

class String {
  alias_method: ":+" for: "+"
  alias_method: ":to_sym" for: "to_sym"
}

class Module {
  def included: module

  def include: modules {
    modules = modules to_a()
    modules reverse_each() |mod| {
      mod append_features: self
      mod send('included, self)
    }
  }
}

class Class{
  def include: modules {
    modules = modules to_a()
    modules reverse_each() |mod| {
      mod append_features: self
      mod send('included, self)
      mod included: self
    }
  }
}
