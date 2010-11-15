# rbx.fy
# This file loads all the rubinius-specific class & method definition
# files from the lib/rbx/ directory in the correct order.

# NOTE:
# Don't change the order in here, unless you know what you're doing.

require: "rbx/documentation"
require: "rbx/object"
require: "rbx/class"
require: "rbx/console"
require: "rbx/array"
require: "rbx/hash"
require: "rbx/false_class"
require: "rbx/string"
require: "rbx/symbol"
require: "rbx/fixnum"
require: "rbx/float"
require: "rbx/bignum"
require: "rbx/block"
require: "rbx/tuple"
require: "rbx/range"
require: "rbx/system"
require: "rbx/exception"
require: "rbx/io"
require: "rbx/file"
require: "rbx/tcp_server"
require: "rbx/regexp"
require: "rbx/directory"
require: "rbx/method"
require: "rbx/environment_variables"
require: "rbx/name_error"
require: "rbx/no_method_error"
