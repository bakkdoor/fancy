#!/usr/bin/env fancy

# A Fancy to rbx bytecode compiler.

require: "compiler/compiler"
require: "compiler/stages"
require: "compiler/ast"

require: "parser"

__FILE__ if_main: {
  require: "compiler/command"
  Fancy Compiler Command run: (ARGV rest)
}
