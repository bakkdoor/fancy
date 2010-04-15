FancySpec describe: "DocStrings" with: |it| {
  it should: "display the docstring for a method" when: {
    docstring = "Array#each: iterates over its elements, calling a given block with each element.";
    Array method: "each:" . docstring: docstring;
    Array method: "each:" . docstring . should_equal: docstring
  }
}
