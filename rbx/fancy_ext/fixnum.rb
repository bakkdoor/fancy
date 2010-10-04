class Fixnum
  alias_method :times_orig, :times
  def times(block)
    times_orig do |i|
      block.call(i)
    end
  end

  define_method("upto:do_each:") do |max, block|
    self.upto(max) do |i|
      block.call(i)
    end
  end
end
