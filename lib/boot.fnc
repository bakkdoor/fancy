# boot.fnc
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# Note:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

require: "object.fnc";
require: "class.fnc";
require: "true_class.fnc";
require: "nil_class.fnc";
require: "number.fnc";
require: "enumerable.fnc";
require: "string.fnc";
require: "array.fnc";
require: "block.fnc";
require: "file.fnc";
require: "directory.fnc";
require: "fancy_spec.fnc";
require: "console.fnc";
require: "hash.fnc";
require: "set.fnc";
require: "symbol.fnc";

# version.fnc holds fancy's version number
require: "version.fnc";


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
   "  --sexp        Print out the Fancy code within a source file as S-Expressions instead of evaluating it "] println
}
