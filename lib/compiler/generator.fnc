def class Rubinius {
  # Temporary
  def class InstructionSequence {
    self read_write_slots: ['opcodes];

    def self from: opcodes {
      is = self allocate;
      is opcodes: opcodes;
      is
    }
  }

  def class Generator {
    self include: GeneratorMethods;

    CALL_FLAG_PRIVATE = 1;
    CALL_FLAG_CONCAT = 2;

    ##
    # Jump label for the branch instructions. The use scenarios for labels:
    #   1. Used and then set
    #        g.gif label
    #        ...
    #        label.set!
    #   2. Set and then used
    #        label.set!
    #        ...
    #        g.git label
    #   3. 1, 2
    #
    # Many labels are only used once. This class employs two small
    # optimizations. First, for the case where a label is used once then set,
    # the label merely records the point it was used and updates that location
    # to the concrete IP when the label is set. In the case where the label is
    # used multiple times, it records each location and updates them to an IP
    # when the label is set. In both cases, once the label is set, each use
    # after that updates the instruction stream with a concrete IP at the
    # point the label is used. This avoids the need to ever record all the
    # labels or search through the stream later to change symbolic labels into
    # concrete IP's.

    def class Label {
      self read_write_slots: ['position];
      self read_slots: ['used, 'basic_block];
      # TODO: translate this:
      # alias_method 'used?, 'used

      def initialize: generator {
        @generator   = generator;
        @basic_block = generator new_basic_block;
        @position    = nil;
        @used        = nil;
        @location    = nil;
        @locations   = nil
      }

      def set! {
        @position = @generator ip;
        @locations if_do: {
          @locations each: |x| { @generator stream at: x put: @position }
        } else: {
          @location if_do: {
            @generator stream at: @location put: @position
          }
        };

        @generator current_block add_edge: @basic_block;
        @generator current_block close;
        @generator current_block: @basic_block;
        @basic_block open
      }

      def used_at: ip {
        @position if_do: {
          @generator stream at: ip put: @position
        } else: {
          @location not if_do: {
            @location = ip
          } else: {
            @locations if_do: {
              @locations << ip
            } else: {
              @locations = [@location, ip]
            }
          }
        };
        @used = true
      }
    }

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
        @max_size = { @stack } if: (@stack > @max_size)
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

    def initialize {
      @stream = [];
      @literals_map = Hash new: |h k| { h at: k put: (self add_literal: k) };
      @literals = [];
      @ip = 0;
      @modstack = [];
      @break = nil;
      @redo = nil;
      @next = nil;
      @retry = nil;
      @last_line = nil;
      @file = nil;
      @lines = [];
      @primitive = nil;
      @instruction = nil;
      @for_block = nil;

      @required_args = 0;
      @total_args = 0;
      @splat_index = nil;
      @local_names = nil;
      @local_count = 0;

      @state = [];
      @generators = [];

      @stack_locals = 0;

      @enter_block = self new_basic_block;
      @current_block = @enter_block;
      @max_stack = 0
    }

    self read_slots: ['ip, 'stream, 'iseq, 'literals];
    self read_write_slots: ['break, 'redo, 'next, 'retry, 'file, 'name,
                            'required_args, 'total_args, 'splat_index,
                            'local_count, 'local_names, 'primitive, 'for_block, 'current_block];

    def execute: node {
      node bytecode: self
    }

    # TODO: translate this:
    # alias_method 'run, 'execute

    # Formalizers

    def encode: encoder {
      @iseq = InstructionSequence from: (@stream to_tuple);

      try {
        # Validate the stack and calculate the max depth
        @enter_block visit: 0
      } catch StdError => e {
        _DEBUG_ if_do: {
          "Error computing stack for " ++ @name ++ ": " ++ (e message)
          ++ " (" ++ (e class) ++ ")" println;
          @iseq show
        };
        e raise!
      };

      @generators each: |x| { @literals[x] encode: encoder }
    }

    def package: klass {
      @generators each: |x| { @literals at: x put: (@literals[x] package: klass) };

      cm = klass new;
      cm iseq:          @iseq;
      cm literals: $    @literals to_tuple;
      cm lines: $       @lines to_tuple;

      cm required_args: @required_args;
      cm total_args:    @total_args;
      cm splat:         @splat_index;
      cm local_count:   @local_count;
      cm local_names: $ { @local_names to_tuple} if: @local_names;

      cm stack_size:    max_stack_size;
      cm file:          @file;
      cm name:          @name;
      cm primitive:     @primitive;

      @for_block if_do: {
        # TODO: translate this:
        # cm add_metadata: 'for_block, true
        # maybe like this:
        # cm meta at: 'for_block put: true
      };

      cm
    }


    # Commands (these don't generate data in the stream)

    def state {
      @state last
    }

    def push_state: scope {
      @state << (AST::State new: scope)
    }

    def pop_state {
      @state pop
    }

    def push_modifiers {
      @modstack << [@break, @redo, @next, @retry]
    }

    def pop_modifiers {
      @break, @redo, @next, @retry = @modstack pop
    }

    def set_line: line {
      { "source code line cannot be nil" raise! } unless: line;

      @last_line if_false: {
        @lines << @ip;
        @lines << line;
        @last_line = line
      } else: {
        (line != @last_line) if_true: {
        # Fold redundent line changes on the same ip into the same
        # entry, except for in the case where @ip is 0. Here's why:
        #
        #   def some_method
        #   end
        #
        # There is nothing in the bytecode stream that corresponds
        # to 'def some_method' so the first line of the method will
        # be recorded as the line 'end' is on.

          (@ip > 0) and: ((@lines[-2]) == @ip) . if_true: {
            @lines at: -1 put: line
          } else: {
            @lines << @ip;
            @lines << line
          };

          @last_line = line
        }
      }
    }

    def line {
      @last_line
    }

    def ip_to_line: ip {
      total = @lines size - 2;
      i = 0;

      (i < total) while_true: {
        (ip >= (@lines[i])) and: (ip <= (@lines[i+2])) . if_true: {
          @lines[i+1]
        } else: {
          i += 2
        }
      }
    }

    def close {
      @lines empty? if_true: {
        msg = "closing a method definition with no line info: " ++ file ++ ":" ++ line;
        msg raise!
      };

      @lines << @ip
    }

    def send_primitive: name {
      @primitive = name
    }

    def new_label {
      Label new: self
    }


    # Helpers

    def new_basic_block {
      BasicBlock new: self
    }

    def accumulate_stack: size {
      @max_stack = { size } if: (size > @max_stack)
    }

    def max_stack_size {
      size = @max_stack + @local_count + @stack_locals;
      { size = size + 1 } if: @for_block;
      size
    }

    def new_stack_local {
      idx = @stack_locals;
      @stack_locals = @stack_locals + 1;
      idx
    }

    def push: what {
      # TODO: translate this:
      # case what
      # when 'true
      #   push_true
      # when 'false
      #   push_false
      # when 'self
      #   push_self
      # when 'nil
      #   push_nil
      # when Integer
      #   push_int what
      # else
      #   raise Error, "Unknown push argument '#{what.inspect}'"
      # end
    }

    def push_generator: generator {
      index = self push_literal: generator;
      @generators << index;
      index
    }

    # Find the index for the specified literal, or create a new slot if the
    # literal has not been encountered previously.
    def find_literal: literal {
      @literals_map[literal]
    }

    # Add literal exists to allow RegexLiteral's to create a new regex literal
    # object at run-time. All other literals should be added via find_literal,
    # which re-use an existing matching literal if one exists.
    def add_literal: literal {
      index = @literals size;
      @literals << literal;
      index
    }

    # Pushes the specified literal value into the literal's tuple
    def push_literal: literal {
      index = self find_literal: literal;
      self emit_push_literal: index;
      index
    }

    # Puts +what+ is the literals tuple without trying to see if
    # something that is like +what+ is already there.
    def push_unique_literal: literal {
      index = self add_literal: literal;
      self emit_push_literal: index;
      index
    }

    # Pushes the literal value on the stack into the specified position in the
    # literals tuple. Most timees, push_literal should be used instead; this
    # method exists to support RegexLiteral, where the compiled literal value
    # (a Regex object) does not exist until runtime.
    def push_literal_at: index {
      self emit_push_literal: index;
      index
    }

    # The push_const instruction itself is unused right now. The instruction
    # parser does not emit a GeneratorMethods#push_const. This method/opcode
    # was used in the compiler before the push_const_fast instruction. Rather
    # than changing the compiler code, this helper was used.
    def push_const: name {
      [self push_const_fast: (self find_literal: name), self add_literal: nil]
    }

    # TODO: translate this:
    # def last_match(mode, which)
    #   push_int Integer(mode)
    #   push_int Integer(which)
    #   invoke_primitive 'regexp_last_match_result, 2
    # end

    # TODO: translate this:
    # def send(meth, count, priv=false)
    #   allow_private if priv

    #   unless count.kind_of? Fixnum
    #     raise Error, "count must be a number"
    #   end

    #   idx = find_literal(meth)

    #   # Don't use send_method, it's only for when the syntax
    #   # specified no arguments and no parens.
    #   send_stack idx, count
    # end

    # Do a private send to self with no arguments specified, ie, a vcall
    # style send.
    def send_vcall: meth {
      idx = self find_literal: meth;
      self send_method: idx
    }

    def send_with_block: meth count: count {
      self send_with_block: meth count: count priv: nil
    }

    def send_with_block: meth count: count priv: priv {
      { self allow_private } if: priv;

      count kind_of?: Fixnum . if_false: {
        "count must be a number" raise!
      };

      idx = self find_literal: meth;

      [self send_stack_with_block: idx, count]
    }

    def send_with_splat: meth args: args {
      self send_with_splat: meth args: args priv: nil concat: nil
    }

    def send_with_splat: meth args: args priv: priv {
      self send_with_splat: meth args: args priv: priv concat: false
    }

    def send_with_splat: meth args: args priv: priv concat: concat {
      val = 0;
      # TODO: translate this:
      # val |= CALL_FLAG_CONCAT  if concat
      { self set_call_flags: val } unless: (val == 0);

      { self allow_private } if: priv;

      idx = self find_literal: meth;
      [self send_stack_with_splat: idx, args]
    }

    def send_super: meth args: args {
      self send_super: meth args: args splat: nil
    }

    def send_super: meth args: args splat: splat {
      idx = self find_literal: meth;

      splat if_do: {
        [self send_super_stack_with_splat: idx, args]
      } else: {
        [self send_super_stack_with_block: idx, args]
      }
    }
  }
}
