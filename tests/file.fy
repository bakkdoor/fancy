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
    lines[0] should == "hello, world!"
    lines[1] should == "line number two"
    lines should == ["hello, world!", "line number two"]

    # delete file
    File delete: filename
    #Directory delete: "tmp/"
    File exists?: filename . should == nil
    #Directory exists?: "tmp/" . should == nil
  }

  it: "should raise an IOError exception when trying to open an invalid file" when: {
    try {
      file = File open: "/foo/bar/baz" modes: ['read]
      nil should == true # this shouldn't execute
    } catch IOError => e {
      e filename should == "/foo/bar/baz"
      e modes should == ['read]
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
    File exists?: filename . should == nil
    File exists?: (filename ++ "-new") . should == true
    File delete: (filename ++ "-new")
    Directory delete: "tmp/"
  }

  it: "should be a directory" for: 'directory?: when: {
    File directory?: "src/" . should == true
    File directory?: "src/bootstrap" . should == true
  }

  it: "should NOT be a directory" for: 'directory?: when: {
    File directory?: "src/Makefile" . should == nil
    File directory?: "README" . should == nil
    File directory?: "src/bootstrap/Makefile" . should == nil
  }
}
