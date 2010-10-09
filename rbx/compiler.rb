#!/usr/bin/env rbx
# -*- ruby -*-

# A fancy to rbx bytecode compiler.
#
#
# This compiler is written in ruby, because I'm
# thinking it's easier to represent the fancy AST
# in ruby than porting all rubinius compiler
# to fancy.
#
# Once we can compile fancy to rubinius we could
# very easily implement the compiler in fancy.
# And still reuse rubinius bytecode generator.
#
# This program is indended to be run using rbx

require 'compiler'
base = File.dirname(__FILE__)
require base + '/compiler/compiler'
require base + '/compiler/stages'
require base + '/compiler/ast'

if __FILE__ == $0
  require base + '/compiler/command'
  Fancy::Compiler::Command.run ARGV
end
