require: "thread"

threads = []
10 times: |i| {
  t = Thread new: {
    "Running Thread #" ++ i println
    i times: {
      "." println
      System sleep: 1500 # sleep 1,5 sec
    }
  }
  threads << t
}

"Waiting for all Threads to end..." print
threads each: |t| {
  t join
}

