#!/usr/bin/env rbx
# -*- ruby -*-



a = eval ARGV[0]

def red(str)
  "\e[1;31m" + str + "\e[0m"
end

def green(str)
  "\e[32m" + str + "\e[0m"
end

def print_indented(to_print, lvl=0)

   if(to_print.is_a? Array)
     puts
     print "  " * lvl
     print "["
     print red ":" + to_print.first.to_s

     print ", " if to_print.size > 1

     1.upto to_print.size do |i|
      print_indented to_print[i], lvl+1
     end

     print "]"

  elsif(to_print)
    puts
    print "  " * lvl

    if(to_print.is_a? Symbol)
      print ":"
      print green to_print.to_s
    elsif to_print.is_a? String
      print "'"
      print green to_print.to_s
      print "'"
    else
      print green to_print.to_s
    end

   end
end

print_indented a
puts
