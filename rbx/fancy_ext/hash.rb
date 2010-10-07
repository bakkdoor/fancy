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
  alias_method :at, "[]"

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

  alias_method :each_key_orig, :each_key
  def each_key(block = nil, &b)
    if block
      self.each_key_orig do |k|
        block.call(k)
      end
    else
      self.each_key_orig(&b)
    end
  end

  alias_method :each_value_orig, :each_value
  def each_value(block = nil, &b)
    if block
      self.each_value_orig do |k|
        block.call(k)
      end
    else
      self.each_value_orig(&b)
    end
  end

  alias_method :map_orig, :map
  def map(block = nil, &b)
    if block
      self.map_orig do |k|
        block.call(k)
      end
    else
      self.map_orig(&b)
    end
  end
end
