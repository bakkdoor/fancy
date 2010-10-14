require File.dirname(__FILE__) + "/compiler"
require File.dirname(__FILE__) + "/parser/parser"

module Fancy


  # Compile fancy code to a compiled method, and load it just like any
  # other compiled file.
  def self.eval(code)
    filename = "(fancy-eval)"
    cm = Rubinius::Compiler.compile_fancy_code(code, filename, 1, true) # always print
    cl = Rubinius::CodeLoader.new(filename)

    script = cm.create_script(false)
    script.file_path = filename

    MAIN.__send__ :__script__
  end

  # Now this is how eval should be done,
  # but currently our FancyGenerator does not take a variable_scope.
  # we need to fix that. In the mean time, we define the previous
  def self.eval_fixme_(code)
    # currently we compile to a CompiledMethod
    # and simply eval it on global scope just like
    # in file loading

    # Copied many things from rbx/common/eval.rb

    binding = Binding.setup(Rubinius::VariableScope.of_sender,
                            Rubinius::CompiledMethod.of_sender,
                            Rubinius::StaticScope.of_sender)

    # hardcoded filename, fix me!
    filename = "(fancy-eval)"

    # The compiled method
    cm = Rubinius::Compiler.compile_fancy_eval(code, binding.variables, filename)
    cm.scope = binding.static_scope.dup
    cm.name = :__fancy_eval__

    script = Rubinius::CompiledMethod::Script.new(cm, filename, true)
    script.eval_binding = binding
    script.eval_source = code

    cm.scope.script = script

    cm.compile

    be = Rubinius::BlockEnvironment.new
    be.under_context binding.variables, cm

    if binding.from_poc?
      be.proc_environment = binding.proc_environment
    end

    be.form_eval!
    be.call
  end
end

if $0 == __FILE__
  if ARGV.length.zero?
    Fancy.eval(STDIN.read)
  else
    if File.exist?(ARGV.first)
      Fancy.eval(File.read(ARGV.first))
    else
      Fancy.eval(ARGV.first)
    end
  end
end
