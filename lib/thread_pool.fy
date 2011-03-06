# This ThreadPool class is adapted from the Ruby code at:
# https://github.com/fizx/thread_pool/

class ThreadPool {
  class Executor {
    read_slot: 'active

    def initialize: queue mutex: mutex {
      @thread = Thread new: {
        loop: {
          mutex synchronize() { @tuple = queue shift() }
          if: @tuple then: {
            args, block = @tuple
            @active = true
            val = nil
            try {
              val = block call: args
            } catch Exception => e {
              e message println
              e backtrace() join: "\n" . println
            }
            block complete: true
            block completed_value: val
          } else: {
            @active = false
            Thread sleep: 0.1
          }
        }
      }
    }

    def close {
      @thread exit
    }
  }

  read_write_slot: 'queue_limit

  # Initialize with number of threads to run
  def initialize: @count limit: @queue_limit (0) {
    @mutex = Mutex new()
    @executors = []
    @queue = []
    @count times: { @executors << (Executor new: @queue mutex: @mutex) }
  }

  # Runs the block at some time in the near future
  def execute: block with_args: args ([]) {
    init_completable: block

    if: (@queue_limit > 0) then: {
      { Thread sleep: 0.1 } until: { @queue size < @queue_limit }
    }

    @mutex synchronize() {
      @queue << [args, block]
    }
  }

  # Runs the block at some time in the near future, and blocks until complete
  def execute_synchronous: block with_args: args ([]) {
    execute: block with_args: args
    { Thread sleep: 0.1 } until: { block complete? }
    block completed_value
  }

  # Size of the task queue
  def waiting {
    @queue size
  }

  # Size of the thread pool
  def size {
    @count
  }

  # Kills all threads
  def close {
    @executors each: |e| { e close }
  }

  # Sleeps and blocks until the task queue is finished executing
  def join {
    { Thread sleep: 0.1 } until: { { @queue empty? } && { @executors all?: |e| { e active not } } }
  }

  class Completable {
    read_write_slot: 'completed_value
    def complete: @complete {
    }

    def complete? {
      @complete not not
    }
  }

  def protected init_completable: block {
    block extend(Completable)
    block complete: false
  }
}