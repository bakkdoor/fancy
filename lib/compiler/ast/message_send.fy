class Fancy AST {
  class MessageSend : Node {
    read_write_slots: ('name, 'receiver, 'args)

    # fast instructions to be used if possible
    FastOps = <[
      ':+ => 'meta_send_op_plus,
      ':- => 'meta_send_op_minus,
      ':== => 'meta_send_op_equal,
      ':=== => 'meta_send_op_tequal,
      ':< => 'meta_send_op_lt,
      ':> => 'meta_send_op_gt
    ]>

    def initialize: @line message: @name      \
        to: @receiver (Self new: @line)       \
        args: @args (MessageArgs new: @line);

    def redirect_via: redirect_message {
      message_name   = SymbolLiteral new: @line value: $ @name string to_sym
      orig_args      = ArrayLiteral new: @line array: $ @args args
      args           = MessageArgs new: @line args: $ [message_name, orig_args]
      redirect_ident = Identifier from: (redirect_message to_s) line: @line

      MessageSend new: @line               \
                  message: redirect_ident  \
                  to: @receiver            \
                  args: args
    }

    def return_send? {
      match @name {
        case Identifier -> @name string == "return"
        case _ -> false
      }
    }

    def bytecode: g {
      pos(g)

      if: (@receiver is_a?: Super) then: {
        SuperSend new: @line message: @name args: @args . bytecode: g
        return nil
      }

      if: return_send? then: {
        Return new: @line expr: @receiver . bytecode: g
        return nil
      }

      @receiver bytecode: g
      @args bytecode: g
      { g allow_private() } if: $ @receiver is_a?: Self

      sym = @name method_name: @receiver ruby_send: ruby_send?
      emit_send: sym bytecode: g
    }

    def emit_send: method_name bytecode: g {
      if: has_splat? then: {
        { g push_nil() } unless: ruby_block?
        g send_with_splat(method_name, @args size, false)
        return nil
      }

      if: ruby_block? then: {
        g send_with_block(method_name, @args size, false)
      } else: {
        # use fast instruction, if available.
        if: (FastOps[method_name]) then: |op| {
          g __send__(op, g find_literal(method_name))
        } else: {
          g send(method_name, @args size, false)
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

    def initialize: @line args: @args ([]);

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
