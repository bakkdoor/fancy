# base = File.expand_path "../", __FILE__

# require: base + "/melbourne"

# require: "/compiler/compiler";
# require: "/compiler/stages";
# require: "/compiler/locals";
# require: "/compiler/ast";
require: "compiler/nodes";
require: "compiler/basic_block";
require: "compiler/label";
require: "compiler/generator_methods";
require: "compiler/generator";
# require: "/compiler/iseq";
# require: "/compiler/opcodes";
# require: "/compiler/compiled_file";
# require: "/compiler/evaluator";
# require: "/compiler/printers"
