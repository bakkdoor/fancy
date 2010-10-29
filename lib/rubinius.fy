# rubinius.fy
# This file loads all the rubinius-specific class & method definition
# files from the lib/rubinius/ directory in the correct order.

# NOTE:
# Don't change the order in here, unless you know what you're doing.

require: "rubinius/object"
require: "rubinius/class"
require: "rubinius/console"
require: "rubinius/array"
require: "rubinius/hash"
require: "rubinius/false_class"
require: "rubinius/string"
require: "rubinius/fixnum"
require: "rubinius/float"
require: "rubinius/bignum"
require: "rubinius/block"
require: "rubinius/system"
require: "rubinius/exception"
require: "rubinius/io"
require: "rubinius/file"
require: "rubinius/tcp_server"
require: "rubinius/regexp"
require: "rubinius/directory"
require: "rubinius/method"
