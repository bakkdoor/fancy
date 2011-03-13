class Future {
  @@thread_pool = nil
  @@pool_size = 10
  WaitInterval = 0.1

  def Future pool: n {
    @@pool_size = match n {
      case 0 -> 10
      case _ -> n
    }
  }

  def Future join! {
    @@thread_pool join
  }

  def initialize: @block {
    { @@thread_pool = ThreadPool new: @@pool_size } unless: @@thread_pool
    @@thread_pool execute: @block
  }

  def when_done: block {
    Future new: {
      value if_do: |v| {
        block call: [v]
      }
    }
  }

  def && block {
    when_done: block
  }

  def value {
    { Thread sleep: WaitInterval } until: { @block complete? }
    @block completed_value
  }
}