# This file will be removed really soon.
# Its here just to help me run the parser ext.
#
# first compile the extension with
#  rbx -S rake
# then run this test
#  rbx test.rb
# expect it to segfault or worse, hehe
#
require File.expand_path("../compiler.rb", File.dirname(__FILE__))
require 'parser'

Fancy::Parser.parse_string(ARGV.first || "\"hello\"")
#Fancy::Parser.parse_string("132")
