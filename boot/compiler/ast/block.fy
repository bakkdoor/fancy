class Fancy AST {
  class BlockLiteral : Rubinius AST Iter {
    def initialize: @line args: @args body: @body (Fancy AST NilLiteral new: line) {
      @body if_nil: { @body = Rubinius AST NilLiteral new(line) }
      initialize(@line, @args, @body)
      @args create_locals: self
      @args total_args == 0 if_true: {
        @arguments prelude=(nil)
      }
      @args.total_args > 1 if_true: {
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

    def initialize: line {
      initialize(line)
      @args = []
    }

    def initialize: line args: @args {
      initialize(line)
      @args = @args map: |a| { a name to_sym() }
    }

    def bytecode: g {
      @args size > 1 if_true: {
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
