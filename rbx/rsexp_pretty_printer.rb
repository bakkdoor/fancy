#!/usr/bin/env rbx
# -*- ruby -*-

module Fancy
  class RSexpPrettyPrinter

    def nice(to_print)

      if to_print.is_a? String
        print_indented eval(to_print)
      elsif to_print.is_a? Array
        print_indented to_print
      end

      puts

    end

    def red(str)
      "\e[1;31m" + str + "\e[0m"
    end

    def green(str)
      "\e[32m" + str + "\e[0m"
    end

    def print_indented(to_print, lvl=0, comma=false)

      if(to_print.is_a? Array)
        puts
        print "  " * lvl
        print "["
        print red ":" + to_print.first.to_s if !to_print.empty?

        print ", " if to_print.size > 1

        1.upto to_print.size do |i|
          if i < (to_print.size - 1)
            print_indented to_print[i], lvl+1, true
          else
            print_indented to_print[i], lvl+1
          end
        end

        print "]"
        print "," if comma


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

  end

end


if __FILE__ == $0
  p = Fancy::RSexpPrettyPrinter.new
  p.nice ARGV[0]
end

