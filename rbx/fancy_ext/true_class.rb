class TrueClass
  define_method("if_true:else:") do |then_block, else_block|
    then_block.call
  end

  def if_true(block)
    block.call
  end

  def if_false(block)
    nil
  end

  def not
      nil
  end
end
