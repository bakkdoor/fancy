class Fancy AST {
  class BlockLiteral : Rubinius AST Iter {
    def initialize: @line args: @args body: @body (NilLiteral new: line) {
      initialize(@line, @args, @body)
      @args create_locals: self
      if: (@args total_args == 0) then: {
        @arguments prelude=(nil)
      }
      if: (@args.total_args > 1) then: {
        @arguments prelude=('multi)
      }
      @arguments required_args=(@args required_args)
    }

    def bytecode: g {
      bytecode(g)
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
