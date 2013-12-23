# in Fancy we use the BlockEnvironment as Block
Block = Rubinius::BlockEnvironment

class Block
  def _fancy_call_(args)
    call(*args)
  end

  alias_method :":call", :call
  alias_method :"call:", :_fancy_call_
end
