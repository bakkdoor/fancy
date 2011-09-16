class FutureSend {
  read_slots: [ 'fail_reason, 'receiver, 'message, 'params ]
  def initialize: @actor receiver: @receiver message: @message with_params: @params ([]) {
    @completed_mutex = Mutex new
    @condvar = ConditionVariable new
    @completed = false
    @failed = false
    @actor ! ('future, (@message, @params), self)
  }

  def failed: @fail_reason {
    synchronized: {
      @completed = true
      @failed = true
      completed!
    }
  }

  def completed: value {
    @completed_mutex synchronize: {
      @value = value
      @completed = true
      completed!
    }
  }

  def completed! {
    @condvar broadcast
  }

  private: 'completed!

  def completed? {
    completed = false
    @completed_mutex synchronize: {
      completed = @completed
    }
    return completed true?
  }

  def failed? {
    failed = false
    @completed_mutex synchronize: {
      failed = @failed
    }
    return failed true?
  }

  def value {
    @completed_mutex synchronize: {
      if: @completed then: {
        return @value
      } else: {
        @condvar wait: @completed_mutex
      }
    }
    return @value
  }

  def send_future: message with_params: params {
    value send_future: message with_params: params
  }

  def when_done: block {
    block send_future: 'call: with_params: [value]
  }

  def && block {
    when_done: block
  }

  def inspect {
    str = "#<FutureSend:0x" ++ (object_id to_s: 16) ++ " @receiver=" ++ @receiver
    str << " @message="
    str << (@message inspect)
    str << " @params="
    str << (@params inspect)
    str + ">"
  }
}

class PooledFuture {
  @@thread_pool = nil
  @@pool_size = 10
  WaitInterval = 0.1

  def PooledFuture pool: n {
    @@pool_size = match n {
      case 0 -> 10
      case _ -> n
    }
  }

  def PooledFuture join! {
    @@thread_pool join
  }

  def initialize: @block {
    { @@thread_pool = ThreadPool new: @@pool_size } unless: @@thread_pool
    @@thread_pool execute: @block
  }

  def when_done: block {
    PooledFuture new: {
      block call: [value]
    }
  }

  def && block {
    when_done: block
  }

  def completed? {
    @block complete?
  }

  def value {
    { Thread sleep: WaitInterval } until: { completed? }
    @block completed_value
  }
}

class FutureCollection {
  include: FancyEnumerable

  def initialize: @futures {
  }

  def each: block {
    @futures each: |f| {
      f when_done: block
    }
  }

  def await_all {
    @futures each: 'value
  }
}