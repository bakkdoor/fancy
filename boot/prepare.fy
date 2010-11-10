#!/usr/bin/env fancy

FancyBoot = self class send('remove_const, "Fancy")

class Fancy {
  CodeLoader = FancyBoot::CodeLoader
  Parser = FancyBoot::Parser
  AST = FancyBoot::AST
}

