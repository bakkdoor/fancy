class Class
  # the define_constructor_class_method: method defines a constructor
  # class method.
  # e.g. for an instance method named "initialize:foo:" we'll define a class
  # method named "new:foo:" which creates a new instance of the class
  # (via allocate) & call the "initialize:foo:" method on it, before
  # returning the new instance.
  # NOTE:
  # the method_name argument to "define_constructor_class_method:"
  # contains only the rest of the method name, not including the
  # "initialize:" or "new:", so we'll have to prepend it ourselves
  define_method("define_constructor_class_method:") do |method_name|
    self.metaclass.send(:define_method, "new:" + method_name) do |*args|
      obj = self.allocate
      obj.__send__("initialize:" + method_name, *args)
      return obj
    end
  end

  define_method(":define_forward_method_missing") do
    define_method("method_missing") do |method_name, *args|
      self.__send__("unknown_message:with_params:", method_name, args)
    end
  end
end
