class Ring {
  class Node {
    def initialize: @next ring: @ring

    def count: count {
      match @next {
        case nil ->
          "DONE: " ++ count println
          @ring finish!
        case _ ->
          "." print
          @next @@ count: (count + 1)
      }
      die! # let this actor die to free resources
    }
  }

  def initialize: amount {
    node = nil
    amount times: {
      node = Node new: node ring: self
    }
    @start = node
  }

  def start: @parent {
    @start count: 1
  }

  def finish! {
    @parent run
  }
}

# create ring and run through it
ring = Ring new: 4000
ring start: $ Thread current
Thread stop # wait until finished