FancySpec describe: FutureSend with: {
  it: "returns a FutureSend" when: {
    def future_send_method {
      "hello, future world!"
    }
    f = self @ future_send_method
    f is_a?: FutureSend . is: true
    f value is: future_send_method
  }

  it: "returns nil for async sends" when: {
    def async_send_method {
      "hello, async world!"
    }
    a = self @@ async_send_method
    a is: nil
  }

  it: "accesses the same future from multiple threads and blocks them until the value is computed" when: {
    def another_method {
      Thread sleep: 0.1
      42
    }

    future = self @ another_method

    threads = (0..10) map: {
      Thread new: {
        future completed? is: false
        future value is: 42
      }
    }

    threads each: 'join
  }

  it: "deals as expected with failures" when: {
    def a_failing_method {
      "error!" raise!
    }
    f = self @ a_failing_method
    f value # wait for completion
    f failure message is: "error!"
    f failed? is: true
  }

  it: "calls a block when done" with: 'when_done: when: {
    called? = false
    failed? = false
    val = 0
    f = { Thread sleep: 0.01; 2 } @ call
    f when_done: |v| {
      val = v
      called? = true
    }
    f when_failed: |err| {
      val = err
      failed? = true
    }

    f value
    called? is: true
    val is: 2
  }

  it: "calls a block when failed" with: 'when_failed: when: {
    called? = false
    failed? = false
    val = 0
    f = { Thread sleep: 0.01; "Fail!" raise! } @ call . tap: @{
      when_done: |v| {
        val = v
        called? = true
      }
      when_failed: |err| {
        val = err
        failed? = true
      }
    }

    f value
    called? is: false
    failed? is: true
    val message is: "Fail!"
    val is_a?: Exception
  }
}

FancySpec describe: FutureCollection with: {
  it: "iterates over each future's value" with: 'each: when: {
    futures = ("a".."z") map: |l| { l @ inspect }
    FutureCollection[futures] each: |val| {
      val =~ /[a-z]/ . is_not: nil
    }
  }

  it: "awaits all futures to complete" with: 'await_all when: {
    futures = (0..100) map: |i| {
      { Thread sleep: 0.01; i * 2 } @ call
    }
    futures all?: @{ completed? } . is: false
    FutureCollection[futures] await_all
    futures all?: @{ completed? } . is: true
  }
}
