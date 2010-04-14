FancySpec describe: File with: |it| {
  it should: "be open after opening it" when: {
    file = File open: "README" mode: "r";
    file open? should_equal: true;
    file close;
    file open? should_equal: nil
  }
}
