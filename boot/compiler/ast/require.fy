class Fancy AST { 
  class Require : Node {
    def initialize: line file: file {
      initialize(line)
      @string = file
    }
    
    def bytecode: g {
      Fancy AST Self new: 1 . bytecode: g
      @string bytecode: g
      pos(g)
      # g allow_private()
      # ms = MessageSend new: "fancy_require" to: g \ 
                       args: [1, false] line: line
      # ms bytecode: g
    }
  }
}