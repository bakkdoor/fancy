#!/usr/bin/env rbx
file = ARGV.shift

cl = Rubinius::CodeLoader.new(file)
cm = cl.load_compiled_file(file, 0)

p cm

script = cm.create_script(false)
script.file_path = "raw.rbc"

MAIN.__script__
