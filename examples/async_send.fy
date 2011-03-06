def bar {
  "In bar!" println
  yield
  "OK, done!" println
}

self @@ bar
self @@ bar
Thread sleep: 1000
self @@ bar
Console readln