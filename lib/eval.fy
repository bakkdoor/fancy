require: "compiler"

def Fancy eval: code binding: binding (nil) file: file ("(fancy-eval)") line: line (1) {
  """
  @code @String@ of Fancy code to be evaluated.
  @binding @Binding@ to evaluate @code in.
  @file @String that is the name of @File@ from which @code is evaluated from (if any).
  @line Starting line, defaults to 1.
  """

  binding if_nil: {
    binding = Binding setup(Rubinius VariableScope of_sender(),
                        Rubinius CompiledMethod of_sender(),
                        Rubinius StaticScope of_sender())
  }

  # The compiled method
  cm = Fancy Compiler compile_code: code vars: (binding variables()) file: file line: line

  # Binding#static_scope was renamed to Binding#constant_scope a while ago.
  # if the new version fails, retry with the old name for backwards compatibility (for now).
  try {
    cm scope=(binding constant_scope() dup())
  } catch NoMethodError => e {
    cm scope=(binding static_scope() dup())
  }
  cm name=('__fancy_eval__)

  script = Rubinius CompiledMethod Script new(cm, file, true)
  script eval_binding=(binding)
  script eval_source=(code)

  cm scope() script=(script)

  be = Rubinius BlockEnvironment new()
  be under_context(binding variables(), cm)

  if: (binding from_proc?()) then: {
    be proc_environment=(binding proc_environment)
  }

  be from_eval!()

  be call()
}
