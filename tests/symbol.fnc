FancySpec describe: Symbol with: |it| {
  it should: "be usable like a block for Enumerable methods" when: {
    [1,2,3,4,5] map: :squared
      . should_equal: [1,4,9,16,25];

    ["hello", "world"] map: :upcase
      . should_equal: ["HELLO", "WORLD"];

    [1,2,3,4,5] select: :even?
      . should_equal: [2,4]
  }
}
