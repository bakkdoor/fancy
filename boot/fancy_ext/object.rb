class Object
  define_method("__AFTER__BOOTSTRAP__:") do |block|
    nil
  end

  define_method("ruby:with_block:") do |method, block|
    self.__send__(method, &block)
  end

  define_method("ruby:args:with_block:") do |method, args, block|
    self.__send__(method, *args, &block)
  end

  define_method("ruby:args:") do |method, args|
    self.__send__(method, *args)
  end

  define_method(":to_s") do
    return self.to_s
  end

  define_method("require:") do |path|
    Fancy::CodeLoader.send "require:", path
  end

  def to_a
    [self]
  end
end

class Fancy
  class BasicObject
    instance_methods.each do |m|
      undef_method(m) if m.to_s !~ /(?:^__|^nil?$|^send$|^object_id$)/
    end
  end
end

class BasicObject
  def method_missing(meth, *args)
    ::Kernel.raise ::NoMethodError, "Unable to send '#{meth}' to instance of #{self.class}"
  end
end