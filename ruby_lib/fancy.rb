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
  def fy(hash_or_name)
    if hash_or_name.is_a? Hash
      self.send("#{hash_or_name.keys.join(':')}:", *hash_or_name.values)
    else
      self.send(":#{hash_or_name}")
    end
  end

  def fancy_require(fancy_file)
    Fancy::CodeLoader.load_compiled_file fancy_file
  end
end
