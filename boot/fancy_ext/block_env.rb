# in Fancy we use the BlockEnvironment as Block
Block = Rubinius::BlockEnvironment

class Block
  define_method("while_true:") do |block|
    while tmp = self.call
      block.call(tmp)
    end
  end

  # call without arguments
  alias_method :":call", :call

  define_method("call:") do |args|
    unless args.is_a? Array
      raise ArgumentError, "Expecting Array of arguments for Block"
    end
    if args.size < self.arity
      raise ArgumentError, "Too few arguments for block: #{args.size} - Minimum of #{self.arity} expected"
    else
      args = args.first(self.arity) if args.size > self.arity
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
