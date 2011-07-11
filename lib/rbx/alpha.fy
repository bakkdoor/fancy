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

  def if_true: then else: else {
    then call: [self]
  }

  def if: cond then: then else: else {
    cond if_true: then else: else
  }

  def unless: cond do: then {
    cond if_true: { nil } else: then
  }

  def unless: cond do: then else: else {
    cond if_true: else else: then
  }

  def _ {
    Object
  }
}

class FalseClass {
  def if_true: then else: else {
    else call
  }
}

class NilClass {
  def if_true: then else: else {
    else call
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