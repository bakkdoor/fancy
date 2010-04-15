FancySpec describe: "DocStrings" with: |it| {
  it should: "display the docstring for a method" when: {
    Array docstring: "Array#each: iterates over its elements, calling a given block with each element." for_method: "each:";
    Array doc_for: "each:" . should_not_equal: "";
    Array doc_for: "each:" . println
  }
}
