class Fiber {
  """
  Fiber class. Fibers are cooperatively scheduled coroutines supported
  by the Rubinius VM.
  Control flow between multiple Fibers is always explicitly handled.
  There is no preemptive scheduler.
  """

  def sleep: seconds {
    @sleep_end = Time now + seconds
  }

  def asleep? {
    if: @sleep_end then: {
      Time now < @sleep_end
    }
  }

  def Fiber name {
    "Fiber"
  }
}