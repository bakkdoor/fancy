class Object
  define_method("ruby:with_block:") do |method, block|
    self.call(method,&block)
  end

  define_method("ruby:args:with_block:") do |method, args, block|
    self.call(method, *args, &block)
  end

  define_method("ruby:args:") do |method, args|
    self.call(method, *args)
  end
end
