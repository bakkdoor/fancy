class String
  def eval
    Kernel::eval(self)
  end
end
