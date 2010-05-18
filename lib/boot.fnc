# boot.fnc
# This file gets loaded & run by Fancy automatically.
# It loads in Fancy's standard library & core classes.

# Note:
# Order DOES matter here, so watch out what you're doing.
# In general, it's best to add any autoload-files at the end of the
# current list (if adding them here is really necessary at all).

require: "lib/object.fnc";
require: "lib/class.fnc";
require: "lib/true_class.fnc";
require: "lib/nil_class.fnc";
require: "lib/number.fnc";
require: "lib/enumerable.fnc";
require: "lib/string.fnc";
require: "lib/array.fnc";
require: "lib/block.fnc";
require: "lib/file.fnc";
require: "lib/fancy_spec.fnc";
require: "lib/console.fnc";
require: "lib/hash.fnc"
