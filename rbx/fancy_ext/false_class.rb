class FalseClass
  define_method("if_true:else:") do |then_block, else_block|
    else_block.call
  end

  def if_true(block)
    nil
  end

  def not
      true
  end
end
