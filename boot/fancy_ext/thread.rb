class Thread
  def __dynamic_vars__
    @dynamic_vars ||= {}
    @dynamic_vars
  end
  private :__dynamic_vars__

  def dynamic_vars
    __dynamic_vars__.keys
  end

  def get_dynamic_variable(var)
    var = var.to_s
    __dynamic_vars__[var]
  end

  def set_dynamic_variable(var, val)
    var = var.to_s
    __dynamic_vars__[var] = val
  end

  def copy_dynamic_variables_from(other_thread)
    other_thread.send(:__dynamic_vars__).each do |var, val|
      self.set_dynamic_variable(var, val)
    end
  end

  class << self
    alias_method :old_new, :new
    def new(*args, &block)
      parent = current
      old_new(*args) do
        current.copy_dynamic_variables_from(parent)
        block.call
      end
    end
  end
end
