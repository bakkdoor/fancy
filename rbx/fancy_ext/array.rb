class Array
  alias_method :each_orig, :each
  def each(block = nil, &b)
    if block
      self.each_orig do |x|
        block.call(x)
      end
    else
      self.each_orig(&b)
    end
  end
end
