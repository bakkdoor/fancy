# pattern_matching.fy
# Examples of pattern matching facilities in fancy

class PatternMatching {
  def match_it: obj {
    obj match: {
      case: String do: $ "It's a String!" println
      case: Fixnum do: $ "It's a Number!" println
      case: _ do: $ "Aything else!" println
    }
  }

  def match_with_extract: str {
    str match: {
      # m holds the MatchData object, m1 & m2 the first and second matches
      case: /^(.*) : (.*)$/ do: |m, m1, m2| {
        "First match: #{m1}" println
        "Second match: #{m2}" println
      }
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
pm match_it: 'foo

pm match_with_extract: "Hello : World!"

# more pattern matching:

def do_it: num {
  (num, num * num)
}

do_it: 10 . match: {
  case: Tuple do: |_, x, y| { # first arg is a Tuple MatchData object (not used here).
    x inspect println # 10
    y inspect println # 100
  }
}