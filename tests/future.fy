FancySpec describe: Future with: {
  it: "should compose Futures to create execution pipelines" for: '&& when: {
    def some_computation: num {
      num upto: (num ** num ** num)
    }

    f = self @ some_computation: 2 && @{select: 'even?} && 'size
    f is_a?: Future . should == true
    f value is_a?: Fixnum . should == true
  }
}
