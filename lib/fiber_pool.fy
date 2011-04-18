class FiberPool {
  def initialize {
    @pool = []
    @scheduling = false
    @mutex = Mutex new()
  }

  def size {
    @mutex synchronize() {
      @pool size
    }
  }

  def add: fiber {
    @mutex synchronize() {
      @pool << fiber
    }
  }

  def remove: fiber {
    @mutex synchronize() {
      @pool remove: fiber
    }
  }

  def scheduling? {
    @scheduling
  }

  def pool {
    @mutex synchronize() {
      pool = @pool
    }
  }

  def cleanup_pool {
    @mutex synchronize() {
      @pool select!: 'alive?
    }
  }

  def schedule {
    @scheduling = true
    Thread new: {
      loop: {
        while: {pool size > 0} do: {
          pool each: |f| {
            unless: (f asleep?) do: {
              sleep_time = f resume
              { f sleep: sleep_time } if: sleep_time
            }
          }
          cleanup_pool
        }
        Thread sleep: 1
      }
    }
  }
}

class Scheduler {
  @@pool = FiberPool new
  def Scheduler add: fiber {
    @@pool add: fiber
    unless: (@@pool scheduling?) do: {
      schedule
    }
    nil
  }

  def Scheduler remove: fiber {
    @@pool remove: fiber
  }

  def Scheduler schedule {
    @@pool schedule
  }
}