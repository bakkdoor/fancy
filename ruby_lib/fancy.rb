base = File.dirname(__FILE__)
require File.expand_path("../boot/fancy_ext", base)
require File.expand_path("../boot/load", base)

Fancy::CodeLoader.load_compiled_file File.expand_path("../lib/boot", base)

# Remove the bootstrapping code loader
bcl = Fancy.send :remove_const, :CodeLoader
bcl.load_compiled_file File.expand_path("../lib/rbx/code_loader", base)

# Initialize the load path
Fancy::CodeLoader.push_loadpath File.expand_path("../lib", base)

# Load compiler+eval support
Fancy::CodeLoader.load_compiled_file File.expand_path("../lib/eval", base)

class Object
  def fancy_message_args name_and_args
    method_name = []
    args = []
    name_and_args.each_with_index do |a, i|
      if i % 2 == 0
        method_name << a
      else
        args << a
      end
    end
    return [method_name.join(":") + ":", args]
  end

  def fy(*array_or_name)
    if array_or_name.size > 1
      message_name, args = fancy_message_args array_or_name
      self.send(message_name, *args)
    else
      self.send(":#{array_or_name}")
    end
  end

  def fancy_require(fancy_file)
    Fancy::CodeLoader.load_compiled_file fancy_file
  end
end
