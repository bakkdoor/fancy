class Fancy AST {

  class Script : Node {
    read_slots: ['file, 'line, 'body]
    def initialize: @line file: @file body: @body {
      super
    }

    def bytecode: g {
      @body bytecode: g
    }
  }

}
