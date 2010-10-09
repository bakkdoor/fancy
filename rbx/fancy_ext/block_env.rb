class Rubinius::BlockEnvironment
  def while_true(block)
    while self.call
      block.call
    end
  end

  alias_method :call_orig, :call
  def call(*args)
    if args.first.is_a? Array
      call_orig *(args.first)
    else
      call_orig *args
    end
  end

  def call_with_receiver(obj)
    call_under obj, method.scope
  end

  define_method("call:with_receiver:") do |args, obj|
    call_under obj, method.scope, *args
  end
end
