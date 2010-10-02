10 times: |i| {
  i println
}

1 upto: 100000 do_each: |i| {
  i println
}

x = 0
{ x < 10 } while_true: {
  "in while_true, with x = " ++ x println
  x = x + 1
}
