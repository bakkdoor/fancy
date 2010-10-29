# boot.fnc
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# NOTE:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

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
require: "hash"
require: "set"
require: "symbol"
require: "method"
require: "stack"

# version holds fancy's version number
require: "version"
require: "argv"

require: "documentation"

# rubinius.fy loads all the files in lib/rubinius/ in the correct
# order, which define all the functionality to let fancy run on rbx.
# also, they might override functionality defined in lib/ to reuse
# existing ruby methods etc.
require: "rubinius.fy"
