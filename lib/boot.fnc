# boot.fnc
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# Note:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

# a hack for "def NATIVE" method definitions:
NATIVE = Object new

require: "object"
require: "class"
require: "true_class"
require: "nil_class"
require: "number"
require: "enumerable"
require: "string"
require: "array"
require: "block"
require: "file"
require: "directory"
require: "fancy_spec"
require: "console"
require: "hash"
require: "set"
require: "symbol"
require: "method"
require: "std_error"
require: "method_not_found"
require: "division_by_zero"
require: "io_error"
require: "type_error"
require: "stack"

# version holds fancy's version number
require: "version"
require: "argv"

ARGV for_options: ["-v", "--version"] do: {
  "fancy " ++ FANCY_VERSION println
  "(C) 2010 Christopher Bertels <chris@fancy-lang.org>" println
}

ARGV for_options: ["--help", "-h"] do: {
  ["Usage: fancy [option] [programfile] [arguments]",
   "  --help        Print this output",
   "  -h            Print this output",
   "  --version     Print Fancy's version number",
   "  -v            Print Fancy's version number",
   "  -I directory  Add directory to Fancy's LOAD_PATH",
   "  -e 'command'  One line of Fancy code that gets evaluated immediately",
   "  --sexp        Print out the Fancy code within a source file as S-Expressions instead of evaluating it ",
   "  -c            Compile given files to Rubinius bytecode",
   "  -rbx          Compile given files to Rubinius bytecode and run it immediately",
   "  --rsexp       Print out the Fancy code within a source file as Ruby S-Expressions instead of evaluating it ",
   "  -o            Output compiled Ruby code to a given file name"] println
}

ARGV for_option: "-e" do: |eval_string| {
  eval_string eval
  System exit # quit when running with -e
}

COMPILE_OUT_STREAM = Console

ARGV for_option: "-o" do: |out_file| {
  COMPILE_OUT_STREAM = File open: out_file modes: ['write]
  out_file_idx = ARGV index: "-o"
  # remove -o with given arg
  2 times: { ARGV remove_at: out_file_idx }
}

ARGV for_option: "-c" do: {
  ARGV index: "-c" . if_do: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      System pipe: ("rbx rubiniusvm/compiler.rb " ++ filename)
    }
  }
  System exit
}

ARGV for_option: "-rbx" do: {
  ARGV index: "-rbx" . if_do: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      System pipe: ("rbx rubiniusvm/compiler.rb " ++ filename)
      System do: ("rbx rubiniusvm/loader.rb " ++ filename ++ ".compiled.rbc")
    }
  }
 System exit
}

ARGV for_option: "--rsexp" do: {
  require: "lib/compiler/nodes.fnc"
  ARGV index: "--rsexp" . if_do: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      exp = System pipe: ("bin/fancy " ++ filename ++ " --sexp")
      exp first eval to_ast to_ruby_sexp: COMPILE_OUT_STREAM
      COMPILE_OUT_STREAM newline
    }
  }
  System exit
}

# close COMPILE_OUT_STREAM if it's a File
COMPILE_OUT_STREAM != Console if_true: {
  COMPILE_OUT_STREAM close
}

