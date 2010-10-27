class PatternMatching {
  def match_it: obj {
    match obj class -> {
      case String -> "It's a String!" println
      case Fixnum -> "It's a Number!" println
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
