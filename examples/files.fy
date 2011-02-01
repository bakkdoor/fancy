# files.fy
# File handling examples

{
  Directory create: "tmp/"
} unless: $ Directory exists?: "tmp/"

File open: "tmp/Hello-World.txt" modes: ['write] with: |f| {
  f writeln: "Hello, world"
}

File delete: "tmp/Hello-World.txt"

arr = [1,2,3,4]
File open: "tmp/Array-Test.txt" modes: ['write] with: |f| {
  arr each: |x| {
    f writeln: x
  }
}

File delete: "tmp/Array-Test.txt"

Directory delete: "tmp/"
