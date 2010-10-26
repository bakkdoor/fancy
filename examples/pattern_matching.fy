class PatternMatching {
  def match_it: obj {
    match obj -> {
      String -> "It's a String!" println
      Number -> "It's a Number!" println
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
