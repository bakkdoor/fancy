FancySpec describe: Set with: {
  it: "should only keep unique values" for: "[]" when: {
    s = Set new
    s << 'foo
    s << 'foo
    s size is == 1
    s is == (Set[['foo]])
    s should_not == ['foo] # Sets and Arrays differ
  }
}
