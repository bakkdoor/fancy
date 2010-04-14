FancySpec describe: File with: |it| {
  it should: "be open after opening it and closed after closing" when: {
    file = File open: "README" mode: :read;
    file open? should_equal: true;
    file close;
    file open? should_equal: nil
  };

  it should: "be closed when not correctly opened" when: {
    file = File new;
    file open? should_equal: nil;
    file close;
    file open? should_equal: nil
  };

  it should: "write and read from a file correctly" when: {
    file = File open: "tmp/read_write_test.txt" mode: :write;
    file writeln: "hello, world!";
    file writeln: "line number two";
    file close;

    file = File open: "tmp/read_write_test.txt" mode: :read;
    lines = [];
    2 times: {
      lines << (file readln)
    };
    lines[0] should_equal: "hello, world!";
    lines[1] should_equal: "line number two"
  }
}
