# in Fancy we use the BlockEnvironment as Block
Block = Rubinius::BlockEnvironment

class Block
  define_method("while_true:") do |block|
    while self.call
      block.call
    end
  end

  # call without arguments
  alias_method :":call", :call

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
