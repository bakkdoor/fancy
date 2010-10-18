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
#require: "std_error"
#require: "method_not_found"
#require: "zero_division"
#require: "io_error"
#require: "type_error"
require: "stack"

# version holds fancy's version number
require: "version"
require: "argv"

