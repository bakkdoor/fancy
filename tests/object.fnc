FancySpec describe: Object with: |it| {
  it should: "dynamically evaluate a message-send with no arguments" when: {
    obj = 42;
    obj send: "to_s" . should_equal: "42"
  };

  it should: "dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world";
    obj send: "from:to:" params: [0,4] . should_equal: "hello"
  }
}
