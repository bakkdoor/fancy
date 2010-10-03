class Object
  def println
    puts self
  end

  def fancy_concat(other)
    self.to_s + other.to_s
  end

  def if_do(block)
    if self
      block.call(self)
    end
  end

  alias_method :"++", :fancy_concat
end
