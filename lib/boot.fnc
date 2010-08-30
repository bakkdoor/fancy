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


# handle ARGV special cases

def ARGV option?: opt {
  opt is_a?: Array . if_true: {
    opt any?: |o| { ARGV include?: o }
  } else: {
    ARGV include?: opt
  }
};

ARGV option?: ["-v", "--version"] .
  if_true: {
  "fancy " ++ FANCY_VERSION println;
  "(C) 2010 Christopher Bertels <chris@fancy-lang.org>" println
};

ARGV option?: ["--help", "-h"] .
  if_true: {
  ["Usage: fancy [option] [programfile] [arguments]",
   "  --help        Print this output",
   "  -h            Print this output",
   "  --version     Print Fancy's version number",
   "  -v            Print Fancy's version number",
   "  -I directory  Add directory to Fancy's LOAD_PATH",
   "  -e 'command'  One line of Fancy code that gets evaluated immediately",
   "  --sexp        Print out the Fancy code within a source file as S-Expressions instead of evaluating it "] println
};

ARGV option?: ["-e"] .
  if_true: {
  idx = (ARGV index: "-e") + 1;
  ARGV[idx] eval
}
