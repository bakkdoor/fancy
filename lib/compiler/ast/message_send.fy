class Fancy AST {

  class MessageSend : Node {
    def initialize: @line message: @name to: @receiver args: @args { }

    def bytecode: g {
      @receiver is_a?: Super . if_do: {
        SuperSend new: @line message: @name args: @args . bytecode: g
      } else: {
        @receiver bytecode: g
        @args bytecode: g
        pos(g)
        @receiver is_a?: Self . if_do: { g allow_private() }
        sym = @name method_name: @receiver ruby_send: (self ruby_send?)
        self ruby_block? . if_do: {
          g send_with_block(sym, @args size, false)
        } else: {
          g send(sym, @args size, false)
        }
      }
    }

    def ruby_send? {
      @args ruby_args?
    }

    def ruby_block? {
      { self ruby_send? } && { @args has_block? }
    }
  }

  class MessageArgs : Node {
    read_slots: ['args]
    def initialize: @line args: @args { }

    def bytecode: g {
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
  }


  class RubyArgs : MessageArgs {
    def initialize: @line args: @args block: @block (nil) {
      @args is_a?: Array . if_false: { @args = @args array }
      @block nil? if_true: {
        @args last kind_of?: Identifier . if_true: {
          @args last string =~ /^&\w/ if_do:  {
            @block = @args pop()
            @block = Identifier new: (@block line) string: (@block string from: 1 to: -1)
          }
        }
      }
    }

    def bytecode: g {
      @args each: |a| {
        a bytecode: g
      }
      { @block bytecode: g } if: @block
    }

    def has_block? {
      @block nil? not
    }
  }

}
