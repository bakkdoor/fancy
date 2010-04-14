File open: "tmp/Hello-World.txt" modes: [:write] with: |f| {
  f write: "Hello, world" . newline
};

arr = [1,2,3,4];
File open: "tmp/Array-Test.txt" modes: [:write] with: |f| {
  arr each: |x| {
    f writeln: x
  }
}

