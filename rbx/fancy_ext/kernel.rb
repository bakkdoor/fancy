module Kernel
  def fancy_require(file)
    file = Fancy::CodeLoader.compile_file! file
    Fancy::CodeLoader.load_compiled_file file
  end
end
