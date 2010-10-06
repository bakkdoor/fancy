class Rubinius::BlockEnvironment
  def while_true(block)
    while self.call
      block.call
    end
  end

  def if(obj)
    if obj
      self.call
    end
  end

  def unless(obj)
    unless obj
      self.call
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
end
