# in Fancy we use the BlockEnvironment as Block
Block = Rubinius::BlockEnvironment

class Block
  # call without arguments
  alias_method :":call", :call

  define_method("call:") do |args|
    call *args
  end
end
