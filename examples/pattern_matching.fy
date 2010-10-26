class PatternMatching {
  def match_it: obj {
    match obj {
      String -> "It's a String!"
    }
  }
}

pm = PatternMatching new
pm match_it: "foo"
pm match_it: 42
