class Rubinius::BlockEnvironment
  define_method("while_true:") do |block|
    while self.call
      block.call
    end
  end

  define_method("call:") do |args|
    if args.first.is_a? Array
      call *(args.first)
    else
      call *args
    end
  end

  define_method("call_with_receiver:") do |obj|
    call_under obj, method.scope
  end

  define_method("call:with_receiver:") do |args, obj|
    call_under obj, method.scope, *args
  end
end
