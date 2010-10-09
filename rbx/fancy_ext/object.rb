class Object
  define_method("ruby:with_block:") do |method, block|
    self.send(method, &block)
  end

  define_method("ruby:args:with_block:") do |method, args, block|
    self.send(method, *args, &block)
  end

  define_method("ruby:args:") do |method, args|
    self.send(method, *args)
  end
end
