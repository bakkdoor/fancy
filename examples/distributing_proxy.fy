class Worker {
  def initialize: @name supervisor: @supervisor
  def work! {
    Thread sleep: 0.5
    @supervisor @@ done: @name
  }
}

class Supervisor {
  def initialize: @amount {
    @done = []
    @workers = Proxies DistributingProxy new: $ (1..@amount) map: |i| { Worker new: i supervisor: self }
  }

  def start {
    "Starting: #{(0..@amount) to_a inspect}" println
    @amount times: {
      @workers @@ work!
    }
  }

  def done: worker {
    @done << worker
    if: (@done size == @amount) then: {
      "Done: #{@done inspect}" println
    }
  }
}

Supervisor new: 10 . start
Console readln