class Future {
  @@thread_pool = nil
  @@pool_size = 10

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

  def value {
    { Thread sleep: 100 } until: { @block complete? }
    @block completed_value
  }
}