def quicksort: arr {
  match arr size -> {
    case (0..1) -> arr
    case _ ->
      piv = arr at: $ rand(arr size)
      (quicksort: $ arr select: |x| { x < piv }) + (quicksort: $ arr select: |x| { x >= piv })
  }
}

arr = 0 upto: 10 . map: { rand(100) }
arr inspect println
quicksort: arr . inspect println
