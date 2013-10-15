require("rubygems")
require("profiler")

Profiler = nil
DEV_NULL = File open: (File NULL) modes: ['write]
def start_profile! {
  Profiler = Rubinius::Profiler::Instrumenter.new#(<['graph => true]>)
  Profiler start()
}
def stop_profile! {
  Profiler stop()
}
def mute! {
  Original_STDOUT = STDOUT
  *stdout* = DEV_NULL
}
def unmute! {
  *stdout* = Original_STDOUT
}
