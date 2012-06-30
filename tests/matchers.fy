FancySpec describe: Matchers with: {
  it: "matches with any value defined matching" when: {
    m = Matchers MatchAny new: 1 with: 2
    m === 0 is: false
    m === 1 is: true
    m === 2 is: true
    m === 3 is_not: true
  }

  it: "matches only with all values defined matching" when: {
    m = Matchers MatchAll new: Integer with: Fixnum
    m === -1 is: true
    m === 0 is: true
    m === 1 is: true
    m === 2.1 is_not: true
    m === 0.0 is_not: true
  }
}
