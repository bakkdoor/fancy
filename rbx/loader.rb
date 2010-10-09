#!/usr/bin/env rbx

# load in fancy specific extensions
require File.dirname(__FILE__) + "/fancy_code_loader"
require File.dirname(__FILE__) + "/fancy_ext"

file = ARGV.shift

# load fancy's stdlib + rubinius extensions
Fancy::CodeLoader.load_compiled_file "lib/rubinius.fyc"

unless File.exists?(file + "c")
  Fancy::CodeLoader.compile_file!(file)
end

# load & run file
Fancy::CodeLoader.load_compiled_file file
