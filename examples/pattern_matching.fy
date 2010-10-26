class PatternMatching {
  def match_it: obj {
    match obj -> {
      case String -> "It's a String!" println
      case Number -> "It's a Number!" println
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
