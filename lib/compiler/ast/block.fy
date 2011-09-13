class Fancy AST {
  class BlockLiteral : Rubinius AST Iter {
    read_slot: 'body
    def initialize: @line args: @args body: @body (NilLiteral new: line) partial: @partial (false) {
      if: (@body empty?) then: {
        @body unshift_expression: $ NilLiteral new: @line
      }
      initialize(@line, @args, @body)
      @args create_locals: self
      if: (@args total_args == 0) then: {
        @arguments prelude=(nil)
      }
      if: (@args.total_args > 1) then: {
        @arguments prelude=('multi)
      }
      @arguments required_args=(@args required_args)

      if: @partial then: {
        first_expr = @body expressions first

        # if first expression is an identifier, use that as a 0-arg
        # method name to send to new receiver (use a generated symbol
        # name created in lib/parser/methods.fy / Fancy Parser#ast:partial_block:)
        # if first expression is a message send where its receiver is
        # an identifier, use that as the message name in a send to
        # self and use the result as the receiver value for the rest.
        new_receiver = Identifier from: (@args args first to_s) line: @line
        match first_expr {
          case Identifier ->
            @body expressions shift()
            @body unshift_expression: $ MessageSend new: @line message: first_expr to: (new_receiver) args: (MessageArgs new: @line args: [])
          case MessageSend ->
            match first_expr receiver {
              case Self ->
                first_expr receiver: new_receiver
              case Identifier ->
                first_expr receiver: $ MessageSend new: @line message: (first_expr receiver) to: (new_receiver) args: (MessageArgs new: @line args: [])
            }
        }
      }
    }

    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class BlockArgs : Node {
    read_write_slots: ['args, 'block]

    def initialize: @line args: @args ([]) {
      @args = @args map: |a| { a name to_sym() }
    }

    def bytecode: g {
      pos(g)
      if: (@args size > 1) then: {
        @args each_with_index: |a i| {
            g shift_array()
            g set_local(i)
            g pop()
        }
      } else: {
        @args each_with_index: |a i| {
          g set_local(i)
        }
      }
    }

    def total_args {
      @args size
    }

    def required_args {
      total_args
    }

    def create_locals: block {
      @args each: |a| {
        block new_local(a)
      }
    }
  }
}
