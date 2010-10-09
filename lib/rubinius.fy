require: "object"
require: "class"
require: "enumerable"
require: "array"
require: "true_class"
require: "nil_class"

require: "rubinius/object"
require: "rubinius/class"
require: "rubinius/console"
require: "rubinius/array"
require: "rubinius/false_class"
require: "rubinius/string"

Dir["lib/rubinius/*.fy"] each: |file| {
  require: file
}
