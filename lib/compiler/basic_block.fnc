def class Rubinius {
  def class BasicBlock {
    def initialize: generator {
      @generator  = generator;
      @ip         = generator ip;
      @closed_ip  = 0;
      @enter_size = 0;
      @max_size   = 0;
      @stack      = 0;
      @edges      = nil;
      @visited    = nil;
      @closed     = nil
    }

    def add_stack: size {
      @stack = @stack + size;
      { @max_size = @stack } if: (@stack > @max_size)
    }

    def add_edge: block {
      @edges = @edges or_take: [];
      @edges << block
    }

    def open {
      @ip = @generator ip
    }

    def close {
      @closed = true;
      @closed_ip = @generator ip
    }

    def location {
      line = @generator ip_to_line: @ip;
      @generator name to_s ++ "line: " ++ line ++ ", IP: " ++ @ip
    }

    def visit: stack_size {
      @visited if_do: {
        (stack_size == @enter_size) if_false: {
          msg = "unbalanced stack at " ++ location ++ ": " ++ stack_size ++ " != " ++ @enter_size;
          CompileError new: msg . raise!
        }
      } else: {
        @visited = true;
        @enter_size = stack_size;

        @closed not if_true: {
          CompileError new: ("control fails to exit properly at " ++ location) . raise!
        };

        @generator accumulate_stack: (@enter_size + @max_size);

        @edges if_do: {
          net_size = stack_size + @stack;
          @edges each: |e| { e visit: net_size }
        }
      }
    }
  }
}
