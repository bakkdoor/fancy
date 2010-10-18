#!/usr/bin/env rbx

base = File.dirname(__FILE__) + "/"

# load in fancy specific extensions
require base + "fancy_code_loader"
require base + "fancy_ext"

# load fancy's stdlib + rubinius extensions
Fancy::CodeLoader.load_compiled_file(base + "../lib/rubinius.fyc")

if $0 == __FILE__
  # load & run file
  file = ARGV.shift
  raise "Expected a fancy file to load" unless file
  if File.exists? file
    Fancy::CodeLoader.load_compiled_file file
  else
    Fancy::CodeLoader.load_compiled_file(base + "../lib/main.fyc")
  end
end
