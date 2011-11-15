# Condition System vars
*restarts* = <[]>
*restarts* documentation: "@Hash@ of currently available restarts (dynamically bound)."
*debugger* = Conditions DefaultDebugger new
*debugger* documentation: "Condition debugger. Defaults to @Conditions::DefaultDebugger@."
*condition_manager* = Conditions Manager new: *debugger*
*condition_manager* documentation: "Instance of @Conditions::Manager@. Used to define @Conditions::Handler@s."