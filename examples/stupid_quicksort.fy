class Array {
  def quicksort {
    match size {
      case (0..1) -> self
      case _ ->
        (rest select: @{ < first } . quicksort) + [first] + (rest select: @{ >= first } . quicksort)
    }
  }
}

(1..10) map: { 100 random } . tap: @{
  inspect println
  quicksort inspect println
}
