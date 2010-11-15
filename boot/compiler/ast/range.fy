class Fancy AST {
  class RangeLiteral : Node {
    read_slots: ['from, 'to]
    def initialize: @line from: @from to: @to {
    }

    def bytecode: g {
      ms = MessageSend new: @line                                           \
                       message: (Identifier from: "new:to:" line: @line)    \
                       to: (Identifier from: "Range" line: @line)           \
                       args: (MessageArgs new: @line args: [@from, @to])
      ms bytecode: g
    }
  }
}
