#!/usr/bin/env rbx
require 'compiler/generator'
g = Rubinius::Generator.new

g.set_line 1
g.push_self
g.push_literal "hello from raw bytecode"
g.send :puts, 1, true
g.ret

g.close

g.encode Rubinius::InstructionSequence::Encoder
cm = g.package Rubinius::CompiledMethod
p cm

output_file = ARGV[0] || "output/raw.rbc"

Rubinius::CompiledFile.dump cm, output_file
