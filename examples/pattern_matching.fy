# pattern_matching.fy
# Examples of pattern matching facilities in fancy

class PatternMatching {
  def match_it: obj {
    match obj -> {
      case String -> "It's a String!" println
      case Fixnum -> "It's a Number!" println
      case _ -> "Aything else!" println
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
pm match_it: 'foo
