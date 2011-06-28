require "delegate"

def DelegateClass(superclass)
  klass = Class.new
  methods = superclass.public_instance_methods(true)
  methods -= ::Kernel.public_instance_methods(false)
  methods -= %w[
    __verify_metaclass__
    copy_from
    singleton_class
    to_marshal
  ]
  methods |= ["to_s","to_a","inspect","==","=~","==="]

  klass.module_eval do
    def initialize(obj)  # :nodoc:
      @_dc_obj = obj
    end

    def method_missing(m, *args)  # :nodoc:
      unless @_dc_obj.respond_to?(m)
        super(m, *args)
      end
      @_dc_obj.__send__(m, *args)
    end

    def respond_to?(m, include_private=false)  # :nodoc:
      return true if super
      return @_dc_obj.respond_to?(m, include_private)
    end

    def __getobj__  # :nodoc:
      @_dc_obj
    end

    def __setobj__(obj)  # :nodoc:
      raise ArgumentError, "cannot delegate to self" if self.equal?(obj)
      @_dc_obj = obj
    end

    def clone  # :nodoc:
      new = super
      new.__setobj__(__getobj__.clone)
      new
    end

    def dup  # :nodoc:
      new = super
      new.__setobj__(__getobj__.dup)
      new
    end
  end

  methods.each do |method|
    begin
      klass.__send__(:define_method, method) do |*args, &block|
        @_dc_obj.__send__(method, *args, &block)
      end
    rescue SyntaxError
      raise NameError, "invalid identifier #{method}"
    end
  end
  return klass
end
