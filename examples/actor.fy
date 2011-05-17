pong = nil

ping = Actor spawn: {
  loop: {
    count = Actor receive
    "." print
    { count println; break } if: (count > 1000)
    pong ! (count + 1)
  }
}

pong = Actor spawn: {
  loop: {
    count = Actor receive
    "-" print
    { count println; break } if: (count > 1000)
    ping ! (count + 1)
  }
}

ping ! 1

# Let the actors process while the main thread sleeps...
Thread sleep: 1