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
Fancy::CodeLoader.load_compiled_file File.expand_path("../lib/rbx/eval", base)

class Fancy
  class RubyResponder < BasicObject
    def initialize(target)
      @target = target
    end

    def method_missing(method, arg = nil, rest = nil)
      message = arg ? "#{method}:" : ":#{method}"
      unless arg
        return @target.__send__(message)
      end
      unless rest
        @target.__send__(message, arg)
      else
        message << rest.keys.join(":") << ":"
        @target.__send__(message, arg, *rest.values)
      end
    end
  end
end

class Object
  def fy(message = nil)
    if message
      case message
      when Hash
        __send__(message.keys.join(":") << ":", *message.values)
      else
        __send__(":#{message}")
      end
    else
      Fancy::RubyResponder.new(self)
    end
  end

  def fancy_require(fancy_file)
    Fancy::CodeLoader.load_compiled_file fancy_file
  end
end
