FancySpec describe: Method with: |it| {
  it should: "display the docstring for a method" when: {
    Array method: :each . docstring println
  }
}
