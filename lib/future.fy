require: "thread_pool"

class Future {
  @@thread_pool = ThreadPool new: 10

  def initialize: @block {
    @@thread_pool execute: @block
  }

  def value {
    { Thread sleep: 100 } until: { @block complete? }
    @block completed_value
  }
}