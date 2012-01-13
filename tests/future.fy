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

  # it: "composes Futures to create execution pipelines" with: '&& when: {
  #   def some_computation: num {
  #     num upto: (num ** num ** num)
  #   }

  #   f = self @ some_computation: 2 && @{select: 'even?} && @{size}
  #   f is_a?: FutureSend . is: true
  #   f value is_a?: Fixnum . is: true
  # }

  it: "accesses the same future from multiple threads and blocks them until the value is computed" when: {
    def another_method {
      Thread sleep: 0.25
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
}