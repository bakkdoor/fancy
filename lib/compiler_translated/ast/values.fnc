def class Rubinius {
  def class AST {
    def class SplatValue : Node {
      self read_write_slots: [:line, :value];

      def self line: line value: value {
        sv = SplatValue new;
        sv line: line;
        sv value: value;
        sv
      }

      def bytecode: g {
        @value bytecode: g;
        { g cast_array } unless: (@value.is_a?: ArrayLiteral)
      }

      def to_sexp {
        [:splat, @value to_sexp]
      }
    };

    def class ConcatArgs : Node {
      self read_write_slots: [:line, :array, :rest, :size];

      def self line: line array: array rest: rest {
        ca = ConcatArgs new;
        ca line: line;
        ca array: array;
        ca size: $ array body size;
        ca rest: rest;
        ca
      }

      def bytecode: g {
        @array bytecode: g;
        @rest bytecode: g;
        g cast_array;
        g send: :+ params: [1]
      }

      def to_sexp {
        [:argscat, @array to_sexp, @rest to_sexp]
      }
    }

    def class SValue : Node {
      self read_write_slots: [:line, :value];

      def self line: line value: value {
        sv = SValue new;
        sv line: line;
        sv value: value;
        sv
      }

      def bytecode: g {
        @value bytecode: g;
        @value is_a?: SplatValue . if_true: {
          done = g new_label;

          g dup;
          g send: :size params: [0];
          g push: 1;
          g send: :> params: [1];
          g git: done;

          g push: 0;
          g send: :at params: [1];

          done set!
        }
      }

      def to_sexp {
        [:svalue, @value to_sexp]
      }
    };

    def class ToArray : Node {
      self read_write_slots: [:line, :value];

      def self line: line value: value {
        ta = ToArray new;
        ta line: line;
        ta value: value;
        ta
      }

      def bytecode: g {
        self pos: g;

        @value bytecode: g;
        g cast_multi_value
      }

      def to_sexp {
        [:to_ary, @value to_sexp]
      }
    };

    def class ToString : Node {
      self read_write_slots: [:line, :value];

      def self line: line value: value {
        ts = ToString new;
        ts line: line;
        ts value: value;
        ts
      }

      def bytecode: g {
        self pos: g;

        @value bytecode: g;
        g send: :to_s params: [0, true]
      }

      def value_defined: g label: f {
        @value if_do: {
          @value value_defined: g label: f
        }
      }

      def to_sexp {
        sexp = [:evstr];
        { sexp << @value to_sexp } if: @value;
        sexp
      }
    }
  }
}
