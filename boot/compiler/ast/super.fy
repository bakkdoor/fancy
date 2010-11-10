class Fancy AST {

  class Super : Node {
    def initialize: @line { super }
  }

  class SuperSend : Node {
    def initialize: @name args: @args line: @line { super }
    def bytecode: g {
      pos(g)
      @args bytecode: g
      g send_super(@name, @args size)
    }
  }

}
