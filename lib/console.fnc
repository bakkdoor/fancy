def class Console {
  "Console class. Used for stdio.";

  def self newline {
    "Prints a newline to stdout.";

    Console println: ""
  }

  def self readln: message {
    "Prints a given message to stdout, followed by reading a line from stdin.";

    Console print: message;
    Console readln
  }
}
