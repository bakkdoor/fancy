class Fancy AST {

  class Super : Node {
    def initialize: @line { }
  }

  class SuperSend : Node {
    def initialize: @line message: @name args: @args { }
    def bytecode: g {
      pos(g)
      @args bytecode: g
      g send_super(@name, @args size)
    }
  }

}
