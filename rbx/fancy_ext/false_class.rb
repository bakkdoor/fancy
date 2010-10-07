class FalseClass
  define_method("if_true:else:") do |then_block, else_block|
    else_block.call
  end

  def if_true(block)
    nil
  end

  def if_false(block)
    block.call
  end

  def not
      true
  end
end
