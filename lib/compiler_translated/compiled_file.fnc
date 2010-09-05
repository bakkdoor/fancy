def class Rubinius {
  ##
  # A decode for the .rbc file format.

  def class CompiledFile {
    self read_write_slots: [:magic, :version, :sum, :stream];

    ##
    # Create a CompiledFile with +magic+ magic bytes, of version +ver+,
    # data containing a SHA1 sum of +sum+. The optional +stream+ is used
    # to lazy load the body.

    def self magic: magic version: ver sum: sum stream: stream {
      cf = CompiledFile new;
      cf magic: magic;
      cf version: version;
      cf sum: sum;
      cf stream: stream;
      cf data: nil;
      cf
    }

    def self magic: magic version: ver sum: sum {
      cf = CompiledFile new;
      cf magic: magic;
      cf version: version;
      cf sum: sum;
      cf stream: nil;
      cf data: nil;
      cf
    }

    ##
    # From a stream-like object +stream+ load the data in and return a
    # CompiledFile object.

    def self load: stream {
      { IOError new: "attempted to load nil stream" . raise! } unless: stream;

      magic = stream gets strip;
      version = Number new: $ stream gets strip;
      sum = stream gets strip;

      CompiledFile magic: magic version: version sum: sum stream: stream
    }

    ##
    # Writes the CompiledFile +cm+ to +file+.
    def self dump: cm file: file {
      try {
        File open: file modes: [:write] with: |f| {
          # TODO: translate this:
          # new("!RBIX", Rubinius::Signature, "x").encode_to(f, cm)
        }
      } catch IOError => e {  # Errno::EACCES
        # just skip writing the compiled file if we don't have permissions
      }
    }

    ##
    # Encode the contets of this CompiledFile object to +stream+ with
    # a body of +body+. Body use marshalled using CompiledFile::Marshal

    def encode_to: stream body: body {
      stream puts: @magic;
      stream puts: $ @version to_s;
      stream puts: $ @sum to_s;

      mar = CompiledFile::Marshal new;
      stream << (mar marshal: body)
    }

    ##
    # Return the body object by unmarshaling the data

    def body {
      @data if_do: {
        @data
      } else: {
        mar = CompiledFile::Marshal new;
        @data = mar unmarshal: stream
      }
    }

    ##
    # A class used to convert an CompiledMethod to and from
    # a String.

    def class Marshal {

      ##
      # Read all data from +stream+ and invoke unmarshal_data

      def unmarshal: stream {
        stream kind_of?: String . if_true:{
          str = stream
        } else: {
          str = stream.read
        };

        @start = 0;
        @size = str size;
        @data = str data;

        self unmarshal_data
      }

      ##
      # Process a stream object +stream+ as as marshalled data and
      # return an object representation of it.

      def private unmarshal_data {
        kind = self next_type
        # TODO: translate this:
        # case kind
        # when ?t
        #   return true
        # when ?f
        #   return false
        # when ?n
        #   return nil
        # when ?I
        #   return next_string.to_i(16)
        # when ?d
        #   str = next_string.chop

        #   # handle the special NaN, Infinity and -Infinity differently
        #   if str[0] == ?\     # leading space
        #     x = str.to_f
        #     e = str[-5..-1].to_i

        #     # This is necessary because (2**1024).to_f yields Infinity
        #     if e == 1024
        #       return x * 2 ** 512 * 2 ** 512
        #     else
        #       return x * 2 ** e
        #     end
        #   else
        #     case str.downcase
        #     when "infinity"
        #       return 1.0 / 0.0
        #     when "-infinity"
        #       return -1.0 / 0.0
        #     when "nan"
        #       return 0.0 / 0.0
        #     else
        #       raise TypeError, "Invalid Float format: #{str}"
        #     end
        #   end
        # when ?s
        #   count = next_string.to_i
        #   str = next_bytes count
        #   discard # remove the \n
        #   return str
        # when ?x
        #   count = next_string.to_i
        #   str = next_bytes count
        #   discard # remove the \n
        #   return str.to_sym
        # when ?p
        #   count = next_string.to_i
        #   obj = Tuple.new(count)
        #   i = 0
        #   while i < count
        #     obj[i] = unmarshal_data
        #     i += 1
        #   end
        #   return obj
        # when ?i
        #   count = next_string.to_i
        #   seq = InstructionSequence.new(count)
        #   i = 0
        #   while i < count
        #     seq[i] = next_string.to_i
        #     i += 1
        #   end
        #   return seq
        # when ?M
        #   version = next_string.to_i
        #   if version != 1
        #     raise "Unknown CompiledMethod version #{version}"
        #   end
        #   cm = CompiledMethod.new
        #   cm.metadata      = unmarshal_data
        #   cm.primitive     = unmarshal_data
        #   cm.name          = unmarshal_data
        #   cm.iseq          = unmarshal_data
        #   cm.stack_size    = unmarshal_data
        #   cm.local_count   = unmarshal_data
        #   cm.required_args = unmarshal_data
        #   cm.total_args    = unmarshal_data
        #   cm.splat         = unmarshal_data
        #   cm.literals      = unmarshal_data
        #   cm.lines         = unmarshal_data
        #   cm.file          = unmarshal_data
        #   cm.local_names   = unmarshal_data
        #   return cm
        # else
        #   raise "Unknown type '#{kind.chr}'"
        # end
      }

      # private :unmarshal_data

      ##
      # Returns the next character in _@data_ as a Fixnum.
      #--
      # The current format uses a one-character type indicator
      # followed by a newline. If that format changes, this
      # will break and we'll fix it.
      #++
      def private next_type {
        chr = @data[@start];
        @start += 2;
        chr
      }

      # private :next_type

      ##
      # Returns the next string in _@data_ including the trailing
      # "\n" character.
      def private next_string {
        count = [@data locate: "\n", @start];
        { count = @size } unless: count;
        str = [String from_bytearray: @data, @start, count - @start];
        @start = count;
        str
      }

      # private :next_string

      ##
      # Returns the next _count_ bytes in _@data_.
      def private next_bytes: count {
        str = [String from_bytearray: @data, @start, count];
        @start = @start + count;
        str
      }

      # private :next_bytes

      ##
      # Returns the next byte in _@data_.
      def private next_byte {
        byte = @data[@start];
        @start = @start + 1;
        byte
      }

      # private :next_byte

      ##
      # Moves the next read pointer ahead by one character.
      def private discard {
        @start = @start + 1
      }

      # private :discard

      ##
      # For object +val+, return a String represetation.

      def marshal: val {
        # TODO: translate this:
        # case val
        # when TrueClass
        #   "t\n"
        # when FalseClass
        #   "f\n"
        # when NilClass
        #   "n\n"
        # when Fixnum, Bignum
        #   "I\n#{val.to_s(16)}\n"
        # when String
        #   "s\n#{val.size}\n#{val}\n"
        # when Symbol
        #   s = val.to_s
        #   "x\n#{s.size}\n#{s}\n"
        # when Tuple
        #   str = "p\n#{val.size}\n"
        #   val.each do |ele|
        #     str.append marshal(ele)
        #   end
        #   str
        # when Float
        #   str = "d\n"
        #   if val.infinite?
        #     str.append "-" if val < 0.0
        #     str.append "Infinity"
        #   elsif val.nan?
        #     str.append "NaN"
        #   else
        #     str.append " %+.54f %5d" % Math.frexp(val)
        #   end
        #   str.append "\n"
        # when InstructionSequence
        #   str = "i\n#{val.size}\n"
        #   val.opcodes.each do |op|
        #     str.append "#{op}\n"
        #   end
        #   str
        # when CompiledMethod
        #   str = "M\n1\n"
        #   str.append marshal(val.metadata)
        #   str.append marshal(val.primitive)
        #   str.append marshal(val.name)
        #   str.append marshal(val.iseq)
        #   str.append marshal(val.stack_size)
        #   str.append marshal(val.local_count)
        #   str.append marshal(val.required_args)
        #   str.append marshal(val.total_args)
        #   str.append marshal(val.splat)
        #   str.append marshal(val.literals)
        #   str.append marshal(val.lines)
        #   str.append marshal(val.file)
        #   str.append marshal(val.local_names)
        #   str
        # else
        #   raise ArgumentError, "Unknown type #{val.class}: #{val.inspect}"
        # end
      }
    }
  }
}
