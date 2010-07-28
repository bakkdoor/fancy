def class Rubinius {
  def class Compiler {
    def class Printer : Stage {
      def initialize {
      }
    };

    def class ASTPrinter : Printer {
      def run {
        @input ascii_graph;
        @output = @input;
        self run_next
      }
    };

    def class SexpPrinter : Printer {
      def run {
        require: "pp";

        @input to_sexp pretty_inspect println;
        @output = @input;
        self run_next
      }
    };

    def class MethodPrinter : Printer {
      self read_write_slots: [:bytecode, :assembly];

      SEPARATOR_SIZE = 40;

      def method_names: names {
        names empty? if_false: {
          @method_names = names map: |n| { n to_sym }
        }
      }

      def match?: name {
        @method_names if_false: {
          true
        } else: {
          @method_names include?: name
        }
      }

      def print_header: cm {
        name = cm name inspect;
        size = (SEPARATOR_SIZE - (name size) - 2) / 2;
        size = { 1 } if: (size <= 0);
        "\n" ++ ("=" * size) ++ " " ++ name ++ " " ++ ("=" * (size + (name size) % 2)) println;
        "Arguments:   " println;
        cm required_args to_s ++ " required, " ++ (cm total_args) ++ " total" print;
        cm splat if_do: { ", (splat)\n" print } else: { "\n" print };
        "Locals:      " ++ (cm local_count) print;
        cm local_count > 0 if_do: { ": " ++ (cm local_names join: ", ") ++ "\n" print } else: { "\n" print };
        "Stack size:  " ++ (cm stack_size) println;
        self print_lines: cm;
        "" println
      }

      def print_footer {
        ("-" * SEPARATOR_SIZE) println
      }

      def print_lines: cm {
        "Lines to IP: " print;
        size = cm lines size - 1;
        i = 1;
        {i < size} while_true: {
          cm lines[i] to_s ++ ": " ++ (cm lines[i - 1]) ++ "-" ++ (cm lines[i + 1] - 1) print;
          i = i + 2;
          { ", " print } if: (i < size)
        };
        "" println
      }

      def print_decoded: cm {
        self match?: (cm name) if_true: {
          self print_header: cm;
          { cm decode } if: @bytecode;
          @assembly if_do: {
            "" println;
            mm = cm make_machine_method;
            mm disassemble
          };
          self print_footer
        }
      }

      def print_method: cm {
        self print_decoded: cm;

        cm literals each: |m| {
          { self next } unless: $ m kind_of?: Rubinius::CompiledMethod;
          self print_method: m
        }
      }

      def run {
        self print_method: @input;

        @output = @input;
        self run_next
      }
    }
  }
}
