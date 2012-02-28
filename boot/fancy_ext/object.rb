class Object
  define_method("__AFTER__BOOTSTRAP__:") do |block|
    nil
  end

  define_method("ruby:with_block:") do |method, block|
    self.send(method, &block)
  end

  define_method("ruby:args:with_block:") do |method, args, block|
    self.send(method, *args, &block)
  end

  define_method("ruby:args:") do |method, args|
    self.send(method, *args)
  end

  define_method(":to_s") do
    return self.to_s
  end

  define_method("require:") do |path|
    Fancy::CodeLoader.send "require:", path
  end

  # HACK:
  # When we define private/protected/public methods, we usually use
  # Module#private, Module#protected & Module#public methods to set the
  # access of that method.
  # But in cases where we define methods not within a class
  # definition, this fails. To make it work, we define these. Kinda
  # stupid, i know, but oh well. Maybe need to fix this in the future.
  def public
    Rubinius::VariableScope.of_sender.method_visibility = nil
  end
  def private
    Rubinius::VariableScope.of_sender.method_visibility = :private
  end
  def protected
    Rubinius::VariableScope.of_sender.method_visibility = :protected
  end
end

class Fancy
  class BasicObject
    instance_methods.each do |m|
      undef_method(m) if m.to_s !~ /(?:^__|^nil?$|^send$|^object_id$)/
    end
  end
end
