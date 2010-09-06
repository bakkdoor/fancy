# boot.fnc
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# Note:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

require: "object";
require: "class";
require: "true_class";
require: "nil_class";
require: "number";
require: "enumerable";
require: "string";
require: "array";
require: "block";
require: "file";
require: "directory";
require: "fancy_spec";
require: "console";
require: "hash";
require: "set";
require: "symbol";
require: "method";

# version holds fancy's version number
require: "version";
require: "argv";

ARGV for_options: ["-v", "--version"] do: {
  "fancy " ++ FANCY_VERSION println;
  "(C) 2010 Christopher Bertels <chris@fancy-lang.org>" println
};

ARGV for_options: ["--help", "-h"] do: {
  ["Usage: fancy [option] [programfile] [arguments]",
   "  --help        Print this output",
   "  -h            Print this output",
   "  --version     Print Fancy's version number",
   "  -v            Print Fancy's version number",
   "  -I directory  Add directory to Fancy's LOAD_PATH",
   "  -e 'command'  One line of Fancy code that gets evaluated immediately",
   "  --sexp        Print out the Fancy code within a source file as S-Expressions instead of evaluating it ",
   "  -c            Compile given files to Ruby code and output to STDOUT or -o option, if given",
   "  -o            Output compiled Ruby code to a given file name"] println
};

ARGV for_option: "-e" do: |eval_string| {
  eval_string eval;
  System exit # quit when running with -e
};;

COMPILE_OUT_STREAM = Console;

ARGV for_option: "-o" do: |out_file| {
  COMPILE_OUT_STREAM = File open: out_file modes: ['write];
  out_file_idx = ARGV index: "-o";
  # remove -o with given arg
  2 times: { ARGV remove_at: out_file_idx }
};

ARGV for_option: "-c" do: {
  require: "lib/compiler/nodes.fnc";
  ARGV index: "-c" . if_do: |idx| {
    ARGV[[idx + 1, -1]] each: |filename| {
      File open: filename modes: ['read] with: |f| {
        lines = [];
        { f eof? } while_false: {
          lines << (f readln)
        };
        COMPILE_OUT_STREAM println: $ "#### " ++ filename ++ ": " ++ "####";
        lines join: "\n" . to_sexp to_ast to_ruby: COMPILE_OUT_STREAM indent: 0
      };
      COMPILE_OUT_STREAM newline;
      COMPILE_OUT_STREAM newline
    }
 };
 System exit # quit when running with -e
};

# close COMPILE_OUT_STREAM if it's a File
COMPILE_OUT_STREAM != Console if_true: {
  COMPILE_OUT_STREAM close
}

