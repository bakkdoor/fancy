class Thread
  def dynamic_vars
    @dynamic_vars ||= []
    @dynamic_vars
  end
  alias_method :set_thread_local, :[]=

  def []=(var, val)
    dynamic_vars << var unless dynamic_vars.include? var
    set_thread_local(var, val)
  end

  class << self
    alias_method :old_new, :new
    def new(*args, &block)
      thread = old_new(*args, &block)
      current.dynamic_vars.each do |v|
        thread[v] = current[v]
      end
      thread
    end
  end
end
