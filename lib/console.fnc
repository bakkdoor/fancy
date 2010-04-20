def class Console {
  def self newline {
    Console println: ""
  }

  def self readln: message {
    Console print: message;
    Console readln
  }
}
