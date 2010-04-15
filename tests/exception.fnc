FancySpec describe: Exception with: |it| {
  it should: "raise an exception" when: {
    try {
      Exception new: "FAIL!" . raise!;
      nil should_equal: true # this should not occur
    } rescue Exception => ex {
      ex message should_equal: "FAIL!"
    }
  }
}
