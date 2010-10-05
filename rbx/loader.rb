#!/usr/bin/env rbx

# load in fancy specific extensions
require File.dirname(__FILE__) + "/fancy_code_loader"
require File.dirname(__FILE__) + "/fancy_ext"

file = ARGV.shift

Fancy::CodeLoader.load_compiled_file file
