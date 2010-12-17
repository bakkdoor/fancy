class Fancy AST {

  class MessageSend : Node {
    read_write_slots: ['name, 'receiver, 'args]
    def initialize: @line message: @name to: @receiver args: @args { }

    def bytecode: g {
      pos(g)
      if: (@receiver is_a?: Super) then: {
        SuperSend new: @line message: @name args: @args . bytecode: g
      } else: {
        @receiver bytecode: g
        @args bytecode: g
        pos(g)
        { g allow_private() } if: (@receiver is_a?: Self)
        sym = @name method_name: @receiver ruby_send: (self ruby_send?)
        if: (self ruby_block?) then: {
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
  }

  class MessageArgs : Node {
    read_slots: ['args]
    def initialize: @line args: @args { }

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
  }


  class RubyArgs : MessageArgs {
    def initialize: @line args: @args block: @block (nil) {
      { @args = @args array } unless: (@args is_a?: Array)
      @block if_nil: {
        if: (@args last kind_of?: Identifier) then: {
          if: (@args last string =~ /^&\w/) then: {
            @block = @args pop()
            @block = Identifier new: (@block line) string: (@block string from: 1 to: -1)
          }
        }
      }
    }

    def bytecode: g {
      pos(g)
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
