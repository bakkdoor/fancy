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
      parent = current
      old_new(*args) do
        parent.dynamic_vars.each do |v|
          current[v] = parent[v]
        end
        block.call
      end
    end
  end
end
