class Ring {
  class Node {
    def initialize: @next ring: @ring { }

    def count: count {
      if: @next then: {
       "." print
        @next @@ count: (count + 1)
      } else: {
        "DONE: " ++ count println
        @ring done: true
      }
      die! # let this actor die to free resources
    }
  }

  read_write_slot: 'done
  def initialize: amount {
    node = nil
    amount times: {
      node = Node new: node ring: self
    }
    @start = node
    @done = false
  }

  def start {
    @start count: 1
  }
}

# create ring and run through it
ring = Ring new: 4000
ring start
until: { ring done } do: {
  Thread sleep: 0.1
}