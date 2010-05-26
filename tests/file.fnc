FancySpec describe: File with: |it| {
  it should: "return an array with the openmodes symbols" when: {
    file = File open: "README" modes: [:read];
    file modes should_equal: [:read];
    file close
  };

  it should: "be open after opening it and closed after closing" when: {
    file = File open: "README" modes: [:read];
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
    filename = "tmp/read_write_test.txt";
    file = File open: filename modes: [:write];
    file writeln: "hello, world!";
    file writeln: "line number two";
    file close;

    File exists?: filename . should_equal: true;
    
    file = File open: filename modes: [:read];
    lines = [];
    2 times: {
      lines << (file readln)
    };
    lines[0] should_equal: "hello, world!";
    lines[1] should_equal: "line number two";
    lines should_equal: ["hello, world!", "line number two"];

    # delete file
    File delete: filename;
    File delete: "tmp/";
    File exists?: filename . should_equal: nil;
    Directory exists?: "tmp/" . should_equal: nil
  };

  it should: "raise an IOError exception when trying to open an invalid file" when: {
    try {
      file = File open: "/foo/bar/baz" modes: [:read];
      nil should_equal: true # this shouldn't execute
    } catch IOError => e {
      e filename should_equal: "/foo/bar/baz";
      e modes should_equal: [:read]
    }
  };

  it should: "rename a File" when: {
    dirname = "tmp/";
    filename = dirname ++ "foobar";

    Directory create: dirname;

    File open: filename  modes: [:write] with: |f| {
      f writeln: "testing!"
    };

    Directory exists?: dirname . should_equal: true;
    File exists?: dirname . should_equal: true;
    File directory?: dirname . should_equal: true;

    File rename: filename to: (filename ++ "-new");
    File exists?: filename . should_equal: nil;
    File exists?: (filename ++ "-new") . should_equal: true;
    File delete: (filename ++ "-new");
    Directory delete: "tmp/"
  };

  it should: "be a directory" when: {
    File directory?: "src/" . should_equal: true;
    File directory?: "src/bootstrap" . should_equal: true
  };

  it should: "NOT be a directory" when: {
    File directory?: "src/Makefile" . should_equal: nil;
    File directory?: "README" . should_equal: nil;
    File directory?: "src/bootstrap/Makefile" . should_equal: nil
  }  
}
