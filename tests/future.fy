FancySpec describe: Future with: {
  it: "should compose Futures to create execution pipelines" for: '&& when: {
    def some_computation: num {
      num upto: (num ** num ** num)
    }

    f = self @ some_computation: 2 && @{select: 'even?} && 'size
    f is_a?: Future . is == true
    f value is_a?: Fixnum . is == true
  }
}

FancySpec describe: FutureCollection with: {
  it: "should execute a block for each future in the collection when it's ready" for: 'each: when: {
    futures = 0 upto: 10 . map: |i| {
      i ** i @ ** i
    }

    fc = FutureCollection new: futures
    fc each: |val| {
      val is_a?: Integer . is == true
    }

    fc await_all
  }
}