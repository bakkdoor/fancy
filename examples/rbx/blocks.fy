2 times: |i| {
  i println
}

1 upto: 4 do_each: |i| {
  i println
}

x = 0
while: { x < 4 } do: {
  "in while_true, with x = " ++ x println
  x = x + 1
}

b = |x, y| {
   "x is: " ++ (x inspect) println
   "y is: " ++ (y inspect) println
   x + y println
}

b call: [1,2]

