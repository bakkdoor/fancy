# *stdout* refers to STDOUT
File open: "/tmp/foo.txt" modes: ['write] with: |f| {
  let: '*stdout* be: f in: {
    # *stdout* refers to f
    # "foo" will be written to /tmp/foo.txt
    # and not STDOUT
    "foo" println
  }
}
File open: "/tmp/foo.txt" modes: ['read] with: |f| {
  let: '*stdin* be: f in: {
    *stdin* readln println # => prints "foo" to *stdout*
  }
}
# *stdout* refers to STDOUT