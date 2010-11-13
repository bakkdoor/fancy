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
        { g allow_private() } if: $ @receiver is_a?: Self
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
      @args first is_a?: RubyArgs
    }

    def has_block? {
      { self ruby_args? } && { @args first has_block? }
    }
  }


  class RubyArgs : MessageArgs {
    def initialize: @line args: @args block: @block (nil) {
      @block nil? if_true: {
        @args array last kind_of?: Identifier . if_true: {
          @args array last identifier =~ /^&\w/ if_do:  {
            @block = @args array pop()
            @block = Identifier new: (block line) string: (block identifier from: 1 to: -1)
          }
        }
      }
    }

    def bytecode: g {
      @args array each: |a| {
        a bytecode: g
      }
      { @block bytecode: g } if: @block
    }

    def size {
      @args array size
    }

    def has_block? {
      @block nil? not
    }
  }

}
