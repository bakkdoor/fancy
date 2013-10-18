module Rubinius
  class ConstantScope
    def const_set_fast(name, value)
      @module.const_set_fast name, value
    end
  end
end
