FancySpec describe: Array with: |it| {
  it should: "contain three number values after adding them" when: {
    @arr = [];
    @arr << 1;
    @arr << 2;
    @arr << 3;
    @arr should_equal: [1,2,3]
  };

  it should: "be empty after clearing it" when: {
    @arr = [1,2,3];
    @arr size should_equal: 3;
    @arr clear;
    @arr size should_equal: 0
  }
}
