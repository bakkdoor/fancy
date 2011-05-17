class FutureSend {
  read_slot: 'fail_reason
  def initialize: @object message: @message with_params: @params ([]) {
    @object __actor__ ! ('future, (@message, @params), self)
  }

  def failed: @fail_reason {
    @completed = true
    @failed = true
  }

  def completed: @value {
    @completed = true
  }

  def completed? {
    @completed
  }

  def value {
    { Thread sleep: 0.1 } until: { completed? }
    @value
  }

  def send_future: message with_params: params {
    value send_future: message with_params: params
  }

  def when_done: block {
    FutureSend new: block message: 'call: with_params: [[value]]
  }

  def && block {
    when_done: block
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