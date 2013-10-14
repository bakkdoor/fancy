#!/usr/bin/env rbx

# A Fancy to rbx bytecode compiler.
#
# This compiler is written in Ruby, because it's easier to start
# writing a working compiler with the given tools of Rubinius that are
# written in Ruby than porting all that code to Fancy.
#
# Once we can compile Fancy to Rubinius we will reimplement the
# compiler in Fancy and can still reuse the rubinius compiler
# toolchain for actual bytecode file generation.
#
# This program is indended to be run using rbx.

require_relative "../fancy_ext"

base = File.dirname(__FILE__)
require_relative 'compiler/compiler'
require_relative 'compiler/stages'
require_relative 'compiler/ast'
require_relative 'parser'

if __FILE__ == $0
  require_relative 'compiler/command'
  Fancy::Compiler::Command.run ARGV
end
