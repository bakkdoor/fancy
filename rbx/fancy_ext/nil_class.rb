class NilClass
  def if_true__else(then_block, else_block)
    else_block.call
  end

  def not
      true
  end
end
