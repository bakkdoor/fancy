#!/usr/bin/env rbx

# load in fancy specific extensions
require File.dirname(__FILE__) + "/fancy_ext"

file = ARGV.shift

cl = Rubinius::CodeLoader.new(file)
cm = cl.load_compiled_file(file, 0)

script = cm.create_script(false)
script.file_path = "raw.rbc"

MAIN.__script__
