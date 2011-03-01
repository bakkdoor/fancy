class Future {
  @@thread_pool = nil
  def initialize: @block {
    { @@thread_pool = ThreadPool new: 10 } unless: @@thread_pool
    @@thread_pool execute: @block
  }

  def value {
    { Thread sleep: 100 } until: { @block complete? }
    @block completed_value
  }
}