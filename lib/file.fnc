def class File {
  def writeln: x {
    "Writes a given argument as a String followed by a newline into the File.";

    self write: x;
    self newline
  }
}
