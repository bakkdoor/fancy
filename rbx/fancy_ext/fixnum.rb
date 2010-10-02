class Fixnum
  def times(block)
    i = 0
    while i < self
      block.call(i)
      i += 1
    end
  end

  def upto__do_each(max, block)
    self.upto(max) do |i|
      block.call(i)
    end
  end
end
