class FutureSend {
  """
  A @FutureSend@ gets created whenever an asynchronous message via the @@ operator gets sent, yielding a @FutureSend@.
  They represent Futures/Promises in Fancy.

  Example:
        f = some_object @ some_method: some_argument
        f class # => FutureSend
        f value # => Value returned by some_method, but may block the current Thread if f hasn't completed yet.
  """

  read_slots: ('receiver, 'message, 'params)
  def initialize: @actor receiver: @receiver message: @message with_params: @params ([]) {
    @completed_mutex = Mutex new
    @condvar = ConditionVariable new
    @completed = false
    @failed = false
    @continuations = []
    @fail_continuations = []
    @actor ! ('future, (@message, @params), self)
  }

  def failed: @fail_reason {
    @completed_mutex synchronize: {
      @completed = true
      @failed = true
      completed!
    }
  }

  def completed: value {
    @completed_mutex synchronize: {
      @value = value
      @completed = true
      completed!
    }
  }

  def completed! {
    @condvar broadcast
    if: @failed then: {
      try {
        @fail_continuations each: @{ call: [@fail_reason] }
      } catch Exception => ex {
        *stderr* println: "Error in FutureSend#completed! while calling fail continuations: #{ex}"
      }
    } else: {
      try {
        @continuations each: @{ call: [@value] }
      } catch Exception => ex {
        *stderr* println: "Error in FutureSend#completed! while calling success continuations: #{ex}"
      }
    }
    @fail_continuations = []
    @continuations = []
  }

  private: 'completed!

  def completed? {
    """
    @return @true if FutureSend completed (success or failure), @false otherwise.
    """

    completed = false
    @completed_mutex synchronize: {
      completed = @completed
    }
    return completed true?
  }

  def succeeded? {
    """
    @return @true if FutureSend completed without failure, @false otherwise.
    """

    completed = false
    failed = false
    @completed_mutex synchronize: {
      completed = @completed
      failed = @failed
    }
    return completed true? && (failed false?)
  }

  def failed? {
    """
    @return @true if FutureSend failed, @false otherwise.
    """

    failed = false
    @completed_mutex synchronize: {
      failed = @failed
    }
    return failed true?
  }

  def failure {
    """
    @return @Exception@ that caused the FutureSend to fail, or @nil, if no failure.

    Returns the @Exception@ that caused @self to fail, or @nil, if it didn't fail.
    Will block the calling @Thread@ if @self hasn't completed or failed yet.
    """

    @completed_mutex synchronize: {
      if: @failed then: {
        return @fail_reason
      } else: {
        @condvar wait: @completed_mutex
      }
    }
    return @fail_reason
  }

  def value {
    """
    @return Return value of performing @self.

    Returns the value returned by performing @self.
    Will block the calling @Thread@ if @self hasn't completed or failed yet.
    """

    @completed_mutex synchronize: {
      if: @completed then: {
        return @value
      } else: {
        @condvar wait: @completed_mutex
      }
    }
    return @value
  }

  def send_future: message with_params: params {
    value send_future: message with_params: params
  }

  def when_failed: block {
    """
    @block @Block@ to be registered as a continuation when @self fails.

    Registers @block as a continuation to be called with @self's fail reason in case of failure.
    """

    { return nil } if: succeeded?
    @completed_mutex synchronize: {
      if: @failed then: {
        block call: [@fail_reason]
      } else: {
        @fail_continuations << block
      }
    }
  }

  def when_done: block {
    """
    @block @Block@ to be registered as a continuation when @self succeeds.

    Registers @block as a continuation to be called with @self's value on success.
    """

    { return nil } if: failed?
    @completed_mutex synchronize: {
      if: @completed then: {
        block call: [@value]
      } else: {
        @continuations << block
      }
    }
  }

  alias_method: 'with_value: for: 'when_done:

  def && block {
    when_done: block
  }

  def inspect {
    str = "#<FutureSend:0x" ++ (object_id to_s: 16) ++ " @receiver=" ++ @receiver
    str << " @message="
    str << (@message inspect)
    str << " @params="
    str << (@params inspect)
    str + ">"
  }
}

class PooledFuture {
  @@thread_pool = nil
  @@pool_size = 10
  WaitInterval = 0.1

  def PooledFuture pool: n {
    @@pool_size = match n {
      case 0 -> 10
      case _ -> n
    }
  }

  def PooledFuture join! {
    @@thread_pool join
  }

  def initialize: @block {
    { @@thread_pool = ThreadPool new: @@pool_size } unless: @@thread_pool
    @@thread_pool execute: @block
  }

  def when_done: block {
    PooledFuture new: {
      block call: [value]
    }
  }

  def && block {
    when_done: block
  }

  def completed? {
    @block complete?
  }

  def value {
    { Thread sleep: WaitInterval } until: { completed? }
    @block completed_value
  }
}

class FutureCollection {
  include: Fancy Enumerable

  def initialize: @futures {
  }

  def each: block {
    @futures each: @{ when_done: block }
  }

  def await_all {
    @futures each: 'value
  }
}