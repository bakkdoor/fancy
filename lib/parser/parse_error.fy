class Fancy {
  class Parser {
    class ParseError : StdError {
      read_slots: ['line, 'filename, 'message]
      def initialize: @line message: @message filename: @filename {
        initialize: $ "Parse error near '" ++ @message ++ "' at line " ++ @line ++ " in " ++ @filename
      }
    }
  }
}
