# In fancy we have an StdError .. maybe we should get rid of it and
# name it StandardError to be ruby compatible.
StdError = StandardError

class Exception
  def raise!
    raise self
  end
end
