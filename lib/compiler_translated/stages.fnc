def class Rubinius {
  def class Compiler {
    Stages = <[]>;

    def class Stage {
      self read_write_slots: [:next_stage, :printer];

      def self stage: name {
        @stage = name;
        Stages at: name put: self
      }

      def self stage_name {
        @stage
      }

      def self next_stage: class {
        @next_stage_class = class
      }

      def self next_stage_class {
        @next_stage_class
      }

      def initialize: compiler_and_last {
        compiler = compiler_and_last[0];
        last = compiler_and_last[1];
        @next_stage = self create_next_stage: compiler last: last
      }

      def input: data {
        @input = data
      }

      def processor: klass {
        @processor = klass
      }

      def create_next_stage: compiler last: last {
        self.class.stage_name == last if_false: {
          stage = self class next_stage_class;
          { stage new: [compiler, last] } if: stage
        }
      }

      def insert: stage {
        tmp = stage next_stage;
        stage next_stage: self;
        @next_stage = tmp
      }

      def run_next {
        @next_stage if_do: {
          @next_stage input: @output;
          @next_stage run
        } else: {
          @output
        }
      }
    };

    # compiled method -> compiled file
    def class Writer : Stage {
      self stage: :compiled_file;
      self read_write_slots: [:name];

      def initialize: compiler_and_last {
        super initialize: compiler_and_last;
        compiler = compiler_and_last[0];
        last = compiler_and_last[1];
        compiler writer: self;
        @processor = Rubinius::CompiledFile
      }

      def run {
        { @name = (@input file) to_s ++ "c" } unless: @name;
        @processor dump: @input name: @name;
        @input
      }
    };

    # encoded bytecode -> compiled method
    def class Packager : Stage {
      self stage: :compiled_method;
      self next_stage: Writer;

      def initialize: compiler_and_last {
        super initialize: compiler_and_last;
        compiler packager: self
      }

      def print {
        self print: MethodPrinter
      }

      def print: class {
        @printer = class new;
        @printer insert: self;
        @printer
      }

      def run {
        @output = @input package: Rubinius::CompiledMethod;
        self run_next
      }
    };

    # symbolic bytecode -> encoded bytecode
    def class Encoder : Stage {
      self stage: :encoded_bytecode;
      self next_stage: Packager;

      def initialize: compiler_and_last {
        super initialize: compiler_and_last;
        compiler encoder: self;
        @encoder = InstructionSequence::Encoder
      }

      def processor: encoder {
        @encoder = encoder
      }

      def run {
        @input encode: @encoder;
        @output = @input;
        self run_next
      }
    };

    # AST -> symbolic bytecode
    def class Generator : Stage {
      self stage: :bytecode;
      self next_stage: Encoder;

      self read_write_slots: [:variable_scope];

      def initialize: compiler_and_last {
        super initialize: compiler_and_last;
        @variable_scope = nil;
        compiler generator: self;
        @processor = Rubinius::Generator
      }

      def run {
        @output = @processor new;
        @input variable_scope: @variable_scope;
        @input bytecode: @output;
        @output close;
        self run_next
      }
    };

    # source -> AST
    def class Parser : Stage {
      self read_write_slots: [:transforms];

      def initialize: compiler_and_last {
        super initialize: compiler_and_last;
        compiler = compiler_and_last[0];
        compiler parser: self;
        @transforms = [];
        @processor = Rubinius::Melbourne
      }

      def root: class {
        @root = class
      }

      def default_transforms {
        @transforms concat: (AST::Transforms category: :default)
      }

      def print {
        self print: ASTPrinter
      }

      def print: class {
        @printer = class new;
        @printer insert: self;
        @printer
      }

      def enable_category: name {
        transforms = AST::Transforms category: name;
        { @transforms concat: transforms } if: transforms
      }

      def enable_transform: name {
        transform = AST::Transforms[name];
        { @transforms << transform } if: transform
      }

      def create {
        @parser = @processor new: [@file, @line, @transforms];
        @parser magic_handler: self;
        @parser
      }

      def add_magic_comment: str {
        (r{-\*-\s*(.*?)\s*(-\*-)$} match: str) if_do: |m| {
          self enable_transform: (m[1] to_sym)
        }
      }

      def run {
        @output = @root new parse;
        @output file: @file;
        self run_next
      }
    };

    # source file -> AST
    def class FileParser : Parser {
      self stage: :file;
      self next_stage: Generator;

      def input: file {
        self input: file line: 1
      }

      def input: file line: line {
        @file = file;
        @line = line
      }

      def parse {
        self create parse_file
      }
    };

    # source string -> AST
    def class StringParser : Parser {
      self stage: :string;
      self next_stage: Generator;

      def input: string {
        self input: string name: "(eval)"
      }

      def input: string name: name {
        self input: string name: name line: 1
      }

      def input: string name: name line: line {
        @input = string;
        @file = name;
        @line = line
      }

      def parse {
        self create parse_string: @input
      }
    }
  }
}
