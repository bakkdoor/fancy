class Fancy {
  class Parser {
    class ParseError : StdError {
      read_slots: ['line, 'filename]
      def initialize: @line message: @message filename: @filename {
        initialize: "Parse error near '#{@message}' at line #{@line} in #{@filename}"
      }
    }
  }
}