FancySpec describe: File with: {
  it: "returns an array with the openmodes symbols" for: 'open:modes: when: {
    file = File open: "README.md" modes: ['read]
    file modes is == ['read]
    file close
  }

  it: "is open after opening it and closed after closing" for: 'close when: {
    file = File open: "README.md" modes: ['read]
    file open? is == true
    file close
    file open? is == false
  }

  it: "is closed when not correctly opened" for: 'open? when: {
    { file = File new } raises: ArgumentError
  }

  it: "writes and reads from a file correctly" for: 'writeln: when: {
    filename = "/tmp/read_write_test.txt"
    file = File open: filename modes: ['write]
    file writeln: "hello, world!"
    file writeln: "line number two"
    file close

    File exists?: filename . is == true

    file = File open: filename modes: ['read]
    lines = []
    2 times: {
      lines << (file readln)
    }
    lines[0] is == "hello, world!\n"
    lines[1] is == "line number two\n"
    lines is == ["hello, world!\n", "line number two\n"]

    # delete file
    File delete: filename
    File exists?: filename . is == false
  }

  it: "raises an IOError exception when trying to open an invalid file" when: {
    { file = File open: "/foo/bar/baz" modes: ['read] } raises: IOError
  }

  it: "renames a File" when: {
    dirname = "tmp/"
    filename = dirname ++ "foobar"

    Directory create: dirname

    File open: filename  modes: ['write] with: |f| {
      f writeln: "testing!"
    }

    Directory exists?: dirname . is == true
    File exists?: dirname . is == true
    File directory?: dirname . is == true

    File rename: filename to: (filename ++ "-new")
    File exists?: filename . is == false
    File exists?: (filename ++ "-new") . is == true
    File delete: (filename ++ "-new")
    Directory delete: "tmp/"
  }

  it: "is a directory" for: 'directory?: when: {
    File directory?: "lib/" . is == true
    File directory?: "lib/rbx" . is == true
  }

  it: "is NOT a directory" for: 'directory?: when: {
    File directory?: "src/Makefile" . is == false
    File directory?: "README" . is == false
    File directory?: "src/bootstrap/Makefile" . is == false
  }
}
