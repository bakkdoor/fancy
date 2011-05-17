fs = []
100 times: |i| {
  f = { Thread sleep: 0.5; i println } @ call
  fs << f
}

"Waiting" println
fs each: 'value
"Done" println