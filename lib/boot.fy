# boot.fy
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# NOTE:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

# rbx.fy loads all the files in lib/rbx/ in the correct order, which
# define all the functionality to let fancy run on rbx.
# also, they might override functionality defined in lib/ to reuse
# existing ruby methods etc.
require: "rbx"

require: "object"
require: "class"
require: "true_class"
require: "nil_class"
require: "false_class"
require: "number"
require: "enumerable"
require: "string"
require: "array"
require: "range"
require: "tuple"
require: "dynamic_slot_object"
require: "block"
require: "iteration"
require: "integer"
require: "enumerator"
require: "file"
require: "directory"
require: "hash"
require: "set"
require: "symbol"
require: "stack"
require: "proxy"
require: "thread_pool"
require: "fiber"
require: "future"
require: "struct"
require: "message_sink"
require: "kvo"

# version holds fancy's version number
require: "version"
require: "argv"
require: "vars"
require: "system"

require: "documentation"

require: "package.fy"
