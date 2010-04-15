FancySpec describe: Method with: |it| {
  it should: "return a Method object" when: {
    Array method: "each:" . _class should_equal: Method
  }
}
