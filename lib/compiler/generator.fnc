def class Rubinius {
  def class Generator {
    self include: GeneratorMethods;

    self read_slots: ['ip, 'stream, 'iseq, 'literals];
    self read_write_slots: ['break, 'redo, 'next, 'retry, 'file, 'name,
                            'required_args, 'total_args, 'splat_index,
                            'local_count, 'local_names, 'primitive, 'for_block, 'current_block];

    def initialize {
      @stream = [];
      @literals = [];
      @ip = 0;
      @modstack = [];

      @last_line = nil;
      @file = nil;
      @lines = [];
      @required_args = 0;
      @total_args = 0;
      @local_names = nil;
      @local_count = 0;

      @state = [];
      @generators = [];

      @stack_locals = 0;

      @enter_block = self new_basic_block;
      @current_block = @enter_block;
      @max_stack = 0
    }

    def new_label {
      Label new: self
    }


    # Helpers

    def new_basic_block {
      BasicBlock new: self
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

    def send_super: meth args: args {
      idx = self find_literal: meth
    }

    def send_super: meth args: args splat: splat {
      idx = self find_literal: meth;
      self send_super_stack_with_block: idx args: args
    }
  }
}
