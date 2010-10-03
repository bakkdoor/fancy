class Object
  def println
    puts self
  end

  def fancy_concat(other)
    self.to_s + other.to_s
  end

  alias_method :"++", :fancy_concat
end
