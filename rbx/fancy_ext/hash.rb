class Hash
  def inspect
    str = "<["
    max = self.size - 1
    i = 0
    self.each do |key,val|
      str += "#{key.inspect} => #{val.inspect}"
      str += ", " if i < max
      i += 1
    end
    str += "]>"
    str
  end

  alias_method "at:put:", "[]="
  alias_method :each_orig, :each

  def each(block = nil, &b)
    if block
      self.each_orig do |k,v|
        block.call(k,v)
      end
    else
      self.each_orig(&b)
    end
  end
end
