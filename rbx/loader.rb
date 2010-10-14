#!/usr/bin/env rbx

# load in fancy specific extensions
require File.dirname(__FILE__) + "/fancy_code_loader"
require File.dirname(__FILE__) + "/fancy_ext"


# load fancy's stdlib + rubinius extensions
Fancy::CodeLoader.load_compiled_file(File.dirname(__FILE__) + "/../lib/rubinius.fyc")

if $0 == __FILE__
  # load & run file
  file = ARGV.shift
  raise "Expected a fancy file to load" unless file
  Fancy::CodeLoader.load_compiled_file file
end
