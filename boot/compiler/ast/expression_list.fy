class Fancy AST {

  class ExpressionList : Node {
    read_slots: ['expressions]
    def initialize: @line list: @expressions ([]) {
        super
    }

    def bytecode: g {
      @expressions each: |e| {
        e bytecode: g
      }
    }
  }

}
