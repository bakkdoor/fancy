##
# Defines all the bytecode instructions used by the VM.

def class Rubinius {
  def class InstructionSet {

    def class OpCode {
      self read_slots: [:args, :arg_count, :bytecode, :opcode, :size,
                        :stack, :stack_consumed, :stack_produced, :variable_stack,
                        :position, :produced_position, :stack_difference, :control_flow];

      self alias_method: :name with: :opcode;
      self alias_method: :width with: :size;

      # TODO: translate this:
      # def initialize(opcode, bytecode, params)
      #   @opcode         = opcode
      #   @bytecode       = bytecode
      #   @args           = params[:args]
      #   @arg_count      = @args.size
      #   @size           = @arg_count + 1
      #   @position       = nil
      #   @produced_position = nil

      #   @stack_consumed, @stack_produced = params[:stack]
      #   if @stack_consumed.kind_of? Fixnum
      #     if @stack_produced.kind_of? Fixnum
      #       @variable_stack = false
      #       @stack_difference = @stack_produced - @stack_consumed
      #     else
      #       @variable_stack = true
      #       produced_extra, @produced_position, @produced_times = @stack_produced
      #       @stack_difference = produced_extra -  @stack_consumed
      #     end
      #   else
      #     @variable_stack = true
      #     extra, @position = @stack_consumed

      #     if @stack_produced.kind_of? Fixnum
      #       @stack_difference = @stack_produced - extra
      #     else
      #       produced_extra, @produced_position, @produced_times = @stack_produced
      #       @stack_difference = produced_extra - extra
      #     end
      #   end

      #   @control_flow = params[:control_flow]
      # end

      def variable_stack? {
        @variable_stack
      }

      def to_s {
        @opcode to_s
      }
    }


    # InstructionSet methods

    # Returns the opcode map.
    def self opcodes_map {
      @opcodes_map =  @opcodes_map or_take: (Rubinius::LookupTable new)
    }

    # Returns an array of OpCode instances.
    def self opcodes {
      @opcodes = @opcodes or_take: []
    }

    # Utility method for defining the opcodes.
    def self opcode: id name: name {
      self opcode: id name: name params: <[]>
    }

    def self opcode: id name: name params: params {
      opcodes at: id put: $ OpCode with_name: name id: id params: params;
      opcodes_map at: name put: id;
      opcodes_map at: id put: id
    }

    # TODO: implement RuntimeError
    def class InvalidOpCode : RuntimeError {
    }

    # Returns an opcode given its name or numeric ID.
    def self [] name_or_id {
      opcode = opcodes[opcodes_map[name_or_id]];
      { InvalidOpCode new: "Invalid opcode " ++ (op inspect) . raise! } unless: opcode;
      opcode
    }
  }

  ##
  # A list of bytecode instructions.


  def class InstructionSequence {
    def initialize: size {
      @opcodes = Tuple new: size
    }

    self read_slots: [:opcodes];

    def == other {
      (other kind_of?: InstructionSequence) and: (@opcodes == (other opcodes))
    }

    def at: idx put: val {
      @opcodes at: idx put: val
    }

    def [] idx {
      @opcodes[idx]
    }

    def size {
      @opcodes size
    }

    ##
    # Encodes an array of symbols representing bytecode into an
    # InstructionSequence

    def class Encoder {

      ##
      # Decodes an InstructionSequence (which is essentially a an array of ints)
      # into an array whose elements are arrays of opcode symbols and 0-2 args,
      # depending on the opcode.

      def decode_iseq: iseq {
        self decode_iseq: iseq symbols_only: true
      }

      def decode_iseq: iseq symbols_only: symbols_only {
        @iseq = iseq;
        @offset = 0;
        stream = [];

        last_good = [nil, 0];

        try {
          @offset < @iseq.size . while_true: {
            inst = self decode;
            stream << inst;
            op = inst first;
            { last_good = [op, stream.size] } unless: (op opcode == :noop)
          }
        } catch InstructionSet::InvalidOpCode => ex {
          # Because bytearrays and iseqs are allocated in chunks of 4 or 8 bytes,
          # we can get junk at the end of the iseq
          last_good first and: (last_good first flow == :return) . if_false: {
            ex message << " at byte " ++ @offset ++ " of " ++ (@iseq size) ++ " [IP:" ++ @offset ++ "]";
            ex raise!
          }
        };

        # Remove any noops or other junk at the end of the iseq
        # HACK Removed for now due to splat handling bug... is this still even necessary?
        #stream.slice! last_good.last, stream.size
        symbols_only if_do: {
          stream each: |i| { i at: 0 put: (i[0] opcode) }
        };

        stream
      }

      ##
      # Encodes a stream of instructions into an InstructionSequence. The stream
      # supplied must be an array of arrays, with the inner array consisting of
      # an instruction opcode (a symbol), followed by 0 to 2 integer arguments,
      # whose meaning depends on the opcode.

      def encode_stream: stream {
        sz = stream reduce: |acc ele| {
          ele is_a?: Array . if_true: {
            acc + (ele size)
          } else: {
            acc + 1
          }
        } with: 0;

        @iseq = InstructionSequence new: sz;
        @offset = 0;

        try {
          stream each: |inst| {
            self encode: inst
          }
        } catch Exception => e {
          STDERR println: "Unable to encode stream:";
          STDERR println: $ stream inspect;
          e raise!
        };

        @iseq
      }

      ##
      # Replaces the instruction at the specified instruction pointer with the
      # supplied instruction inst, which must be an array containing the new
      # instruction opcode symbol, followed by any int args required by the
      # opcode.
      #
      # The new instruction must be the same width or smaller than the
      # instruction it replaces.

      def replace_instruction: iseq ip: ip instruction: inst {
        @iseq = iseq;
        @offset = ip;
        start = ip;

        old_inst = self iseq2int;
        old_op = InstructionSet[old_inst];
        new_op = inst first;
        new_op is_a?: (InstructionSet::OpCode) . if_false: {
          new_op = InstructionSet[inst first]
        };
        @offset = @offset + (old_op arg_count);
        old_op size upto: (new_op size - 1) do_each: {
          next_inst = self iseq2int;
          next_inst == 0 . if_false: {
            ArgumentError new: "Cannot replace an instruction with a larger instruction (existing "
            ++ (old_op opcode) ++ " / new " ++ (new_op opcode)
            . raise!
          }
        };

        @offset = start;
        replaced = [old_op opcode];
        1 upto: (old_op arg_count) do_each: {
          replaced << self iseq2int;
          self int2iseq: 0    # Replace any old opcode args with 0 (i.e. noop)
        };

        @offset = start;
        self encode: inst;
        replaced
      }

      ##
      # Decodes a single instruction at the specified instruction pointer
      # address.

      def decode_instruction: iseq ip: ip {
        @iseq = iseq;
        @offset = ip;

        self  decode
      }

      def private decode {
        inst = self iseq2int;
        op = InstructionSet[inst]

        # TODO: translate this:
        # case op.arg_count
        # when 0
        #   [op]
        # when 1
        #   [op, iseq2int]
        # when 2
        #   [op, iseq2int, iseq2int]
        # end
      }

      def private iseq2int {
        op = @iseq[@offset];
        @offset = @offset + 1;
        op
      }

      def private int2iseq: op {
        @iseq at: @offset put: op;
        @offset = @offset + 1;
        op
      }

      # TODO: translate this:
      # def encode(inst)
      #   if inst.kind_of? Array
      #     opcode = inst.first
      #     unless opcode.kind_of? InstructionSet::OpCode
      #       opcode = InstructionSet[opcode]
      #     end

      #     arg_count = opcode.arg_count
      #     unless inst.size - 1 == arg_count
      #       raise ArgumentError, "Missing instruction arguments to #{inst.first} (need #{arg_count} / got #{inst.size - 1})"
      #     end
      #   else
      #     opcode = inst
      #     arg_count = 0
      #     unless opcode.kind_of? InstructionSet::OpCode
      #       opcode = InstructionSet[opcode]
      #     end
      #   end

      #   begin
      #     @iseq[@offset] = opcode.bytecode
      #     case arg_count
      #     when 1
      #       @iseq[@offset + 1] = inst[1].to_i
      #     when 2
      #       @iseq[@offset + 1] = inst[1].to_i
      #       @iseq[@offset + 2] = inst[2].to_i
      #     end
      #     @offset += (1 + arg_count)
      #   rescue => e
      #     raise ArgumentError, "Unable to encode #{inst.inspect}"
      #   end
      # end

      # private :encode

    }

    ##
    # Decodes the instruction sequence into an array of symbols

    def decode {
      self decode: true
    }

    def decode: symbols_only {
      enc = Encoder new;
      enc decode_iseq: self symbols_only: symbols_only
    }

    def show {
      ip = 0;
      self decode each: |inst| {
        # TODO: translate this:
        # puts "%4s: %s" % [ip, inst.join(" ")]
        ip = ip + (inst size)
      }
    }
  }
}
