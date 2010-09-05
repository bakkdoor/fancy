def class Rubinius {

  def class CompileError : StdError {
  }

  def class Compiler {
    self read_write_slots: [:parser, :generator, :encoder, :packager, :writer];

    def self compiler_error: msg orig: orig {
      # TODO: translate this:
      # if defined?(RUBY_ENGINE) and RUBY_ENGINE == "rbx"
      #   raise Rubinius::CompileError, msg, orig
      # else
      #   orig.message.replace("#{orig.message} - #{msg}")
      #   raise orig
      # end
    }

    def self compiled_name: file {
      file suffix?: ".rb" . if_true: {
        file + "c"
      } else: {
        file + ".compiled.rbc"
      }
    }

    # TODO: translate this:
    # def self.compile(file, output=nil, line=1, transforms=:default)
    #   compiler = new :file, :compiled_file

    #   parser = compiler.parser
    #   parser.root AST::Script

    #   if transforms.kind_of? Array
    #     transforms.each { |t| parser.enable_category t }
    #   else
    #     parser.enable_category transforms
    #   end

    #   parser.input file, line

    #   writer = compiler.writer
    #   writer.name = output ? output : compiled_name(file)

    #   begin
    #     compiler.run
    #   rescue SyntaxError => e
    #     raise e
    #   rescue Exception => e
    #     compiler_error "Error trying to compile #{file}", e
    #   end

    # end

    # Match old compiler's signature
    def self compile_file_old: file flags: flags {
      self compile_file: file line: 1
    }

    def self compile_file: file {
      self compile_file: file line: 1
    }

    def self compile_file: file line: line {
      compiler = self from: :file to: :compiled_method;

      parser = compiler parser;
      parser root: AST::Script;
      parser default_transforms;
      parser input: file line: line;

      try {
        compiler run
      } catch StdError => e {
        self compiler_error: ("Error trying to compile " ++ file) error: e
      }
  }

    def self compile_string: string {
      self compile_string: string file: "(eval)" line: 1
    }

    def self compile_string: string file: file {
      self compile_string: string file: file line: 1
    }

    def self compile_string: string file: file line: line {
      compiler = self from: :string to: :compiled_method;

      parser = compiler parser;
      parser root: AST::Script;
      parser default_transforms;
      parser input: string file: file line: line;
      compiler run
    }

    def self compile_eval: string variable_scope: variable_scope {
      self compile_eval: string variable_scope: variable_scope file: "(eval)" line: 1
    }

    def self compile_eval: string variable_scope: variable_scope file: file {
      self compile_eval: string variable_scope: variable_scope file: file line: 1
    }

    def self compile_eval: string variable_scope: variable_scope file: file line: line {
      compiler = self from: :string to: :compiled_method;

      parser = compiler parser;
      parser root: AST::EvalExpression;
      parser default_transforms;
      parser input: string file: file line: line;

      compiler generator variable_scope: variable_scope;

      compiler run
    }

    def self compile_test_bytecode: string transforms: transforms {
      compiler = self from: :string to: :bytecode;

      parser = compiler parser;
      parser root: AST::Snippet;
      parser input: string;
      transforms each: |x| { parser enable_transform: x };

      compiler generator processor: TestGenerator;

      compiler run
    }

    def self from: from to: to {
      obj = self new: [from, to];
      obj
    }

    def initialize: arr_from_to {
      from, to = arr_from_to;
      @start = Stages[from] new: [self, to]
    }

    def run {
      @start run
    }
  }
}
