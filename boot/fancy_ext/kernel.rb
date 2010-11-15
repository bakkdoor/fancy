module Kernel

  alias_method :":metaclass", :metaclass

  def fancy_require(file, compile = false)
    if compile
      file = Fancy::CodeLoader.compile_file! file
    end
    find_file = !compile
    Fancy::CodeLoader.load_compiled_file file, find_file
  end
end
