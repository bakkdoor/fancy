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

    def ruby_send? { @args kind_of?(RubyArgs) }
    def ruby_block? { { self ruby_send? } && { @args has_block? } }
  }

  class MessageArgs : Node {
    def initialize: @line args: @array { }

    def bytecode: g {
      @array each: |a| { a bytecode: g }
    }

    def size { @array size }
  }


  class RubyArgs : MessageArgs {

  }

}
