class Fiber {
  """
  Fiber class. Fibers are cooperatively scheduled coroutines supported
  by the Rubinius VM.
  Control flow between multiple Fibers is always explicitly handled.
  There is no preemptive scheduler.
  """

  def Fiber name {
    "Fiber"
  }

  def Fiber inspect {
    name
  }
}