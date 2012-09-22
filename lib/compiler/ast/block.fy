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

      if: (@args total_args > 1) then: {
        @arguments prelude=('multi)
      }

      @arguments required_args=(@args required_args)

      if: @partial then: {
        @body = ExpressionList new: @line list: $ @body expressions map: |e| { convert_to_implicit_arg_send: e }
      }
    }

    def convert_to_implicit_arg_send: expr {
      # if expression is an identifier, use that as a 0-arg
      # message name to send to new receiver (use a generated symbol
      # name created in lib/parser/methods.fy / Fancy Parser#ast:partial_block:)
      # if expression is a message send where its receiver is
      # an identifier, use that as the message name in a send to
      # self and use the result as the receiver value for the rest.
      new_receiver = Identifier from: (@args args first to_s) line: @line
      match expr {
        case Identifier ->
          expr = MessageSend new: @line message: expr to: new_receiver args: (MessageArgs new: @line args: [])
        case MessageSend ->
          match expr receiver {
            case Self ->
              expr receiver: new_receiver
            case Identifier ->
              expr receiver: $ MessageSend new: @line message: (expr receiver) to: (new_receiver) args: (MessageArgs new: @line args: [])
            case MessageSend ->
              expr receiver: $ convert_to_implicit_arg_send: $ expr receiver
          }
      }
      expr
    }

    def bytecode: g {
      pos(g)
      bytecode(g)
    }
  }

  class BlockArg : Node {
    def initialize: @line ident: @ident

    def name {
      @ident name
    }

    def to_s {
      name to_s
    }

    def bytecode: g then: block {
      g shift_array()
      if: (@ident name != '_) then: block else: {
        g pop()
      }
    }

    def create_local: block {
      if: (@ident name != '_) then: {
        block new_local(@ident name)
      }
    }
  }

  class DestructuringBlockArg : Node {
    def initialize: @line args: @args

    def bytecode: g then: block {
      g shift_array()

      @args each_with_index: |a i| {
        if: (a name != '_) then: {
          g dup()
          FixnumLiteral new: @line value: i . bytecode: g
          g send('at:, 1, false)
          block call
        }
      }
    }

    def create_local: block {
      @args each: @{ create_local: block }
    }
  }

  class BlockArgs : Node {
    read_write_slots: ['args, 'block]

    def initialize: @line args: @args ([]);

    def bytecode: g {
      pos(g)
      if: (@args size > 1) then: {
        local_offset = 0
        @args each: |a| {
          a bytecode: g then: {
            g set_local(local_offset)
            g pop()
            local_offset = local_offset + 1
          }
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
      @args each: @{ create_local: block }
    }
  }
}
