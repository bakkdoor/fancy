FancySpec describe: Set with: |it| {
  it should: "only keep unique values" when: {
    s = Set new;
    s << :foo;
    s << :foo;
    s size should_equal: 1;
    s should_equal: (Set[[:foo]]);
    s should_not_equal: [:foo] # Sets and Arrays differ
  }
}
