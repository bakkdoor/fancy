def bar {
  "In bar!" println
  Thread sleep: 1
  "OK, done!" println
}

self @@ bar
Thread sleep: 1
self @@ bar
Console readln