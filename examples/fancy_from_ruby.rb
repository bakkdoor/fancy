require_relative "../ruby_lib/fancy.rb"

0.fy upto: 10, do: :println
"Hello, World".fy(split: ", ").fy each: ->(w) { puts(w) }

# or use this api:
0.fy.upto(10, do: :println)
"hello, world".fy.split(", ").fy.each(->(w) { puts(w) })
