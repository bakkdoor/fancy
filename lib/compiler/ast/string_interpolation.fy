class Fancy AST {
  class StringInterpolation : Node {
    """
    StringInterpolation nodes need to be parsed after the overall code has been parsed
    as the parser currently isn't re-entrant.
    It works...
    """

    def initialize: @line code: @code filename: @filename
    def parse_code {
      Fancy Parser parse_code: @code file: @filename line: @line
    }
    def bytecode: g {
      parse_code body expressions first bytecode: g
    }
  }
}
