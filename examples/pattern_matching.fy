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

  def match_with_extract: str {
    match str -> {
      # m holds the MatchDate object, m1 & m2 the first and second matches
      case /^(.*) : (.*)$/ -> |m, m1, m2|
        "First match: #{m1}" println
        "Second match: #{m2}" println
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
pm match_it: 'foo

pm match_with_extract: "Hello : World!"