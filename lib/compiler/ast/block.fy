class Fancy AST {
  class BlockLiteral : Rubinius AST Iter {
    def initialize: @line args: @args body: @body (NilLiteral new: line) partial: @partial (false) {
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
        # method name to send to self (via call_with_receiver
        # (see boot/fancy_ext/block_env.rb).
        # if first expression is a message send where its receiver is
        # an identifier, use that as the message name in a send to
        # self and use the result as the receiver value for the rest.

        match first_expr -> {
          case Identifier ->
            @body expressions shift()
            @body unshift_expression: $ MessageSend new: @line message: first_expr to: (Self new: @line) args: (MessageArgs new: @line args: [])
          case MessageSend ->
            match first_expr receiver -> {
              case Identifier ->
                first_expr receiver: $ MessageSend new: @line message: (first_expr receiver) to: (Self new: @line) args: (MessageArgs new: @line args: [])
            }
        }
      }
    }

    def bytecode: g {
      bytecode(g)
      if: @partial then: {
        g dup()
        g send('set_as_partial, 0, false)
        g pop()
      }
    }
  }

  class BlockArgs : Node {
    read_write_slots: ['args, 'block]

    def initialize: @line args: @args ([]) {
      @args = @args map: |a| { a name to_sym() }
    }

    def bytecode: g {
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
      self total_args
    }

    def create_locals: block {
      @args each: |a| {
        block new_local(a)
      }
    }
  }
}
