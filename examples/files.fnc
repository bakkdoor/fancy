File open: "Hello-World.txt" mode: "w" with: |f| {
  f write: "Hello, world" . newline
};

arr = [1,2,3,4];
File open: "Array-Test.txt" mode: "w" with: |f| {
  arr each: |x| {
    f writeln: x
  }
}

