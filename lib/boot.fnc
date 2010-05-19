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
require: "fancy_spec.fnc";
require: "console.fnc";
require: "hash.fnc";
require: "set.fnc"
