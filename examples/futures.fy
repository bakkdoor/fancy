if: (ARGV[1]) then: |n| {
  "Using #{n} threads" println
  Future pool: $ n to_i
}

fs = []
100 times: |i| {
  f = { Thread sleep: 0.5; i println } @ call
  fs << f
}

"Waiting" println
fs each: 'value
"Done" println