class Fiber {
  def sleep: seconds {
    @sleep_end = Time now + seconds
  }

  def asleep? {
    if: @sleep_end then: {
      Time now < @sleep_end
    }
  }
}