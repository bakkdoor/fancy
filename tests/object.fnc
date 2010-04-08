FancySpec describe: Object with: |it| {
  it should: "dynamically evaluate a message-send with no arguments" when: {
    obj = 42;
    obj send: "to_s" . should_equal: "42"
  };

  it should: "dynamically evaluate a message-send with a list of arguments" when: {
    obj = "hello, world";
    obj send: "from:to:" params: [0,4] . should_equal: "hello"
  };

  it should: "dynamically define slotvalues" when: {
    obj = Object new;
    obj get_slot: :foo . should_equal: nil;
    obj set_slot: :foo with: "hello, world";
    obj get_slot: :foo . should_equal: "hello, world"
  }
}
