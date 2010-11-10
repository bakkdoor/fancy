#!/usr/bin/env fancy

# A Fancy to rbx bytecode compiler.

require: "compiler/compiler"
require: "compiler/stages"
require: "compiler/ast"

require: "parser"

__FILE__ == $0 . if_do: {
  require: "compiler/command"
  Fancy Compiler Command run: ARGV
}
