require File.dirname(__FILE__) + "/compiler"

module Fancy

  def self.eval(code, binding = nil, filename = "(fancy-eval)", line = 1)
    # Copied many things from rbx/common/eval.rb

    binding ||= Binding.setup(Rubinius::VariableScope.of_sender,
                              Rubinius::CompiledMethod.of_sender,
                              Rubinius::StaticScope.of_sender)

    # The compiled method
    cm = Compiler.compile_fancy_eval(code, binding.variables, filename, line)
    cm.scope = binding.static_scope.dup
    cm.name = :__fancy_eval__

    script = Rubinius::CompiledMethod::Script.new(cm, filename, true)
    script.eval_binding = binding
    script.eval_source = code

    cm.scope.script = script

    be = Rubinius::BlockEnvironment.new
    be.under_context binding.variables, cm

    if binding.from_proc?
      be.proc_environment = binding.proc_environment
    end

    be.from_eval!

    be.call
  end

end

if $0 == __FILE__
  require File.dirname(__FILE__) + "/loader"
  if ARGV.length.zero?
    Fancy.eval(STDIN.read)
  else
    ARGV.each do |arg|
      if File.exist?(arg)
        Fancy.eval(File.read(arg))
      else
        Fancy.eval(arg)
      end
    end
  end
end
