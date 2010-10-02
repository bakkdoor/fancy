class Rubinius::BlockEnvironment
  def while_true(block)
    while self.call
      block.call
    end
  end
end
