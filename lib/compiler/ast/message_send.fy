class Fancy AST {
  class MessageSend : Node {
    read_write_slots: ['name, 'receiver, 'args]

    def initialize: @line message: @name to: @receiver (Self new: @line) args: @args (MessageArgs new: @line) {
    }

    def redirect_via: redirect_message {
      message_name = SymbolLiteral new: @line value: (@name string to_sym)
      orig_args = ArrayLiteral new: @line array: $ @args args
      args = MessageArgs new: @line args: $ [message_name, orig_args]

      ms = MessageSend new: @line \
                       message: (Identifier from: (redirect_message to_s) line: @line) \
                       to: @receiver \
                       args: args
    }

    def bytecode: g {
      pos(g)
      if: (@receiver is_a?: Super) then: {
        SuperSend new: @line message: @name args: @args . bytecode: g
      } else: {

        # check if we might have a block invocation using block(x,y) syntax.
        if: ruby_send? then: {
          if: (@receiver is_a?: Self) then: {
            if: (g state() scope() search_local(@name name)) then: {
              @name bytecode: g
              args = ArrayLiteral new: @line array: (@args args)
              args bytecode: g
              g send('call:, 1, false)
              return nil
            }
          }
        }

        @receiver bytecode: g
        @args bytecode: g
        pos(g)
        { g allow_private() } if: (@receiver is_a?: Self)

        sym = @name method_name: @receiver ruby_send: ruby_send?
        if: has_splat? then: {
          { g push_nil() } unless: ruby_block?
          g send_with_splat(sym, @args size, false)
          return nil
        }
        if: ruby_block? then: {
          g send_with_block(sym, @args size, false)
        } else: {
          g send(sym, @args size, false)
        }
      }
    }

    def ruby_block? {
      @args has_block?
    }

    def ruby_send? {
      @args ruby_args?
    }

    def has_splat? {
      @args has_splat?
    }
  }

  class MessageArgs : Node {
    read_slot: 'args

    def initialize: @line args: @args ([]) {
    }

    def bytecode: g {
      pos(g)
      @args each: |a| {
        a bytecode: g
      }
    }

    def size {
      @args size
    }

    def ruby_args? {
      is_a?: RubyArgs
    }

    def has_block? {
      false
    }

    def has_splat? {
      false
    }
  }


  class RubyArgs : MessageArgs {
    def initialize: @line args: @args ([]) block: @block (nil) {
      { @args = @args array } unless: (@args is_a?: Array)
      @block if_nil: {
        if: (@args last kind_of?: Identifier) then: {
          if: (@args last string =~ /^&\w/) then: {
            @block = @args pop()
            @block = Identifier from: (@block string from: 1 to: -1) line: (@block line)
          }
        }
      }

      if: (@args last kind_of?: Identifier) then: {
        if: (@args last string =~ /^\*\w/) then: {
          @splat = @args pop()
          @splat = Identifier from: (@splat string from: 1 to: -1) line: (@splat line)
        }
      }
    }

    def bytecode: g {
      pos(g)
      @args each: |a| {
        a bytecode: g
      }
      { @splat bytecode: g; g cast_array() } if: @splat
      { @block bytecode: g } if: @block
    }

    def has_block? {
      @block nil? not
    }

    def has_splat? {
      @splat nil? not
    }
  }
}
