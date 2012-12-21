FancySpec describe: File with: {
  it: "returns an array with the openmodes symbols" with: 'open:modes: when: {
    file = File open: "README.md" modes: ['read]
    file modes is: ['read]
    file close
  }

  it: "reads a file correctly" with: 'read:with: when: {
    lines = File read: "README.md" . lines
    idx = 0

    File read: "README.md" with: |f| {
      until: { f eof? } do: {
        lines[idx] is: (f readline chomp)
        idx = idx + 1
      }
    }
  }

  it: "writes a file correctly" with: 'write:with: when: {
    dirname = "tmp"
    filename = "#{dirname}/write_test.txt"

    Directory create!: dirname
    File write: filename with: |f| {
      10 times: |i| {
        f println: i
      }
    }

    File read: filename . lines is: $ ["0","1","2","3","4","5","6","7","8","9"]
    File delete: filename
    Directory delete: dirname
  }

  it: "is open after opening it and closed after closing" with: 'close when: {
    file = File open: "README.md" modes: ['read]
    file open? is: true
    file close
    file open? is: false
  }

  it: "is closed when not correctly opened" with: 'open? when: {
    { file = File new } raises: ArgumentError
  }

  it: "writes and reads from a file correctly" with: 'writeln: when: {
    filename = "/tmp/read_write_test.txt"
    file = File open: filename modes: ['write]
    file writeln: "hello, world!"
    file writeln: "line number two"
    file close

    File exists?: filename . is: true

    file = File open: filename modes: ['read]
    lines = []
    2 times: {
      lines << (file readln)
    }
    lines[0] is: "hello, world!\n"
    lines[1] is: "line number two\n"
    lines is: ["hello, world!\n", "line number two\n"]

    # delete file
    File delete: filename
    File exists?: filename . is: false
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

    Directory exists?: dirname . is: true
    File exists?: dirname . is: true
    File directory?: dirname . is: true

    File rename: filename to: (filename ++ "-new")
    File exists?: filename . is: false
    File exists?: (filename ++ "-new") . is: true
    File delete: (filename ++ "-new")
    Directory delete: "tmp/"
  }

  it: "is a directory" with: 'directory?: when: {
    File directory?: "lib/" . is: true
    File directory?: "lib/rbx" . is: true
  }

  it: "is NOT a directory" with: 'directory?: when: {
    File directory?: "src/Makefile" . is: false
    File directory?: "README" . is: false
    File directory?: "src/bootstrap/Makefile" . is: false
  }

  it: "evals a file" with: 'eval: when: {
    "/tmp/test_#{Time now to_i}.fy" tap: |filename| {
      File tap: @{
        write: filename with: @{ print: "2 * 3 to_s inspect" }
        eval: filename . is: $ 6 to_s inspect
        delete: filename
      }
      # File write: filename with: @{ print: "2 * 3 to_s inspect" }
      # File eval: filename . is: $ 6 to_s inspect
      # File delete: filename
    }
  }

  it: "reads a config file" with: 'read_config: when: {
    contents = """
    {
      test: 'value
      other: 123
      more: {
        again: 'foo
        yup: [1,2,3]
      }
    }
    """

    filename = "/tmp/#{Time now to_i random}_fy_test.txt"
    File write: filename with: @{ write: contents }
    File read_config: filename . is: <[
      'test => 'value,
      'other => 123,
      'more => <[
        'again => 'foo,
        'yup => [1,2,3]
      ]>
    ]>
    File delete: filename
  }

  it: "overwrites a file correctly" with: 'overwrite:with: when: {
    filename = "/tmp/#{Time now to_i random}_overwrite_test.fy"
    try {
      File write: filename with: @{ println: "foo"; println: "bar" }
      File read: filename . is: "foo\nbar\n"
      File overwrite: filename with: @{ println: "bar"; println: "foo" }
      File read: filename . is: "bar\nfoo\n"
    } finally {
      File delete!: filename
    }
  }
}
