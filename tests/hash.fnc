FancySpec describe: Hash with: |it| {
  it should: "be empty on initialization" when: {
    hash = <[]>;
    hash size should_equal: 0;
    hash empty? should_equal: true
  }
}
