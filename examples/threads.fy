# threads.fy
# Example of threads in fancy

threads = []
10 times: |i| {
  t = Thread new: {
    "Running Thread #" ++ i println
    i times: {
      "." print
      Thread sleep: 1.5 # sleep 1,5 sec
    }
  }
  threads << t
}

"Waiting for all Threads to end..." print
threads each: 'join

