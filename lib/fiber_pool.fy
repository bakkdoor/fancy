class FiberPool {
  def initialize {
    @pool = []
    @current = nil
  }

  def size {
    @pool size
  }

  def add: fiber {
    @pool << fiber
  }

  def remove: fiber {
    @pool remove: fiber
  }

  def schedule {
    Thread new: {
      loop: {
        while: {@pool size > 0} do: {
          @pool each: |f| {
            f resume
          }
          @pool select!: 'alive?
        }
        Thread sleep: 1000
      }
    }
  }
}

class Scheduler {
  @@pool = FiberPool new
  def Scheduler add: fiber {
    @@pool add: fiber
  }

  def Scheduler remove: fiber {
    @@pool remove: fiber
  }

  def Scheduler schedule {
    @@pool schedule
  }
}