FancySpec describe: File with: {
  it: "should return an array with the openmodes symbols" for: 'open:modes: when: {
    file = File open: "README" modes: ['read]
    file modes should == ['read]
    file close
  }

  it: "should be open after opening it and closed after closing" for: 'close when: {
    file = File open: "README" modes: ['read]
    file open? should == true
    file close
    file open? should == false
  }

  # it: "should be closed when not correctly opened" for: 'open? when: {
  #   file = File new
  #   file open? should == nil
  #   file close
  #   file open? should == nil
  # }

  it: "should write and read from a file correctly" for: 'writeln: when: {
    filename = "/tmp/read_write_test.txt"
    file = File open: filename modes: ['write]
    file writeln: "hello, world!"
    file writeln: "line number two"
    file close

    File exists?: filename . should == true

    file = File open: filename modes: ['read]
    lines = []
    2 times: {
      lines << (file readln)
    }
    lines[0] should == "hello, world!\n"
    lines[1] should == "line number two\n"
    lines should == ["hello, world!\n", "line number two\n"]

    # delete file
    File delete: filename
    File exists?: filename . should == false
  }

  it: "should raise an IOError exception when trying to open an invalid file" when: {
    try {
      file = File open: "/foo/bar/baz" modes: ['read]
      nil should == true # this shouldn't execute
    } catch IOError => e {
      #e filename should == "/foo/bar/baz"
      #e modes should == ['read]
    }
  }

  it: "should rename a File" when: {
    dirname = "tmp/"
    filename = dirname ++ "foobar"

    Directory create: dirname

    File open: filename  modes: ['write] with: |f| {
      f writeln: "testing!"
    }

    Directory exists?: dirname . should == true
    File exists?: dirname . should == true
    File directory?: dirname . should == true

    File rename: filename to: (filename ++ "-new")
    File exists?: filename . should == false
    File exists?: (filename ++ "-new") . should == true
    File delete: (filename ++ "-new")
    Directory delete: "tmp/"
  }

  it: "should be a directory" for: 'directory?: when: {
    File directory?: "lib/" . should == true
    File directory?: "lib/rubinius" . should == true
  }

  it: "should NOT be a directory" for: 'directory?: when: {
    File directory?: "src/Makefile" . should == false
    File directory?: "README" . should == false
    File directory?: "src/bootstrap/Makefile" . should == false
  }
}
