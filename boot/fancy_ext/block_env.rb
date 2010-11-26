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
    if @partial
      call_under args.first, method.scope, *(args[1..-1])
    else
      if args.first.is_a? Array
        call *(args.first)
      else
        call *args
      end
    end
  end

  define_method("call_with_receiver:") do |obj|
    call_under obj, method.scope
  end

  define_method("call:with_receiver:") do |args, obj|
    call_under obj, method.scope, *args
  end

  def set_as_partial
    @partial = true
  end
end
