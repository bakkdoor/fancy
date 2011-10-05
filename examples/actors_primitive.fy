pong = nil
done = false
Parent = Thread current

ping = Actor spawn: {
  loop: {
    count = Actor receive
    "." print
    { count println; done = true; break } if: (count > 1000)
    pong ! (count + 1)
  }
  Parent run
}

pong = Actor spawn: {
  loop: {
    count = Actor receive
    "-" print
    { count println; done = true; break } if: (count > 1000)
    ping ! (count + 1)
  }
  Parent run
}

ping ! 1

# Let the actors process while the main thread sleeps...
Thread stop