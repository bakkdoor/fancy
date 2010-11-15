class Fancy AST {
  class Return : Node {
    def initialize: @line expr: @expr {
    }

    def bytecode: g {
      @expr bytecode: g
      g raise_return()
    }
  }

  class ReturnLocal : Node {
    def initialize: @line expr: @expr {
    }

    def bytecode: g {
      @expr bytecode: g
      g ret()
    }
  }
}