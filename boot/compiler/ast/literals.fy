class Fancy AST {

  class FixnumLiteral : Rubinius AST FixnumLiteral {
    include Node
    def initialize: value line: line { initialize(line, value) }
  }

  class StringLiteral : Rubinius AST StringLiteral {
    def initialize: value line: line { initialize(line, value) }
    def bytecode: g { bytecode(g) }
  }

  class Self : Node {
    def initialize: @line { super }
    def bytecode: g { g push_self() }
  }

}
