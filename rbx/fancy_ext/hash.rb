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
end
