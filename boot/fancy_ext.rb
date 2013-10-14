# The fancy_ext directory contains Rubinius-specific code (mostly
# extension methods) for existing classes that need to be defined in
# Ruby in order for Fancy to work correctly on rbx.
# The amount of code should be kept as small as possible, as we want
# to write as much in Fancy as possible.

base = File.dirname(__FILE__) + "/fancy_ext/"
require base + "thread"
require base + "kernel"
require base + "module"
require base + "object"
require base + "block_env"
require base + "class"
require base + "string_helper"
require base + "console"
require base + "delegator"
require base + "symbol"
require base + "array"

unless Rubinius::VERSION =~ /^1\./
  begin
    require "rubygems"
    require "rubinius/toolset"
    require "rubinius/compiler"

    Rubinius::Compiler  = Rubinius::ToolSet.current::TS::Compiler
    Rubinius::AST       = Rubinius::ToolSet.current::TS::AST
    Rubinius::Generator = Rubinius::ToolSet.current::TS::Generator
  rescue NameError
  end
end
