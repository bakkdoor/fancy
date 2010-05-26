def class File {
  def self exists?: filename {
    "Indicates, if a File exists with a given filename.";
    try {
      f = File open: filename modes: [:read];
      f close;
      true
    } catch IOError => e {
      nil
    }
  }

  def writeln: x {
    "Writes a given argument as a String followed by a newline into the File.";

    self write: x;
    self newline
  }
}
