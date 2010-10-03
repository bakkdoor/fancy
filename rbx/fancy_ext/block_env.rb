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
end
