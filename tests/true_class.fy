FancySpec describe: TrueClass with: {
  it: "should be true for calling and: with non-nil value" for: 'and: when: {
    true and: true . should == true
    true and: 'bar . should == true
  }

  it: "should be false for calling and: with a nil value" for: 'and: when: {
    true and: nil . should == nil
  }

  it: "should be true for calling && with non-nil value" for: '&& when: {
    (true && true) should == true
    (true && 'bar) should == true
  }

  it: "should be false for calling && with a nil value" for: '&& when: {
    (true && nil) should == nil
  }

  it: "should be true for calling or: with both non-nil values" for: 'or: when: {
    true or: true . should == true
  }

  it: "should be true for calling or: with any values" for: 'or: when: {
    true or: nil . should == true
    true or: true . should == true
    true or: 'foo . should == true
  }

  it: "should be true for calling || with both non-nil values" for: '|| when: {
    (true || true) should == true
  }

  it: "should be true for calling || with any values" for: '|| when: {
    (true || nil) should == true
    (true || true) should == true
    (true || 'foo) should == true
  }

  it: "should call the then-block" for: 'if_true:else: when: {
    true if_true: { 'then } else: { 'else } . should == 'then
  }

  it: "should NOT call the block" for: 'if_false: when: {
    true if_false: { 'false } . should == nil
  }

  it: "should NOT be nil" for: 'nil? when: {
    true nil? should == nil
  }

  it: "should NOT be false" for: 'false? when: {
    true false? should == nil
  }

  it: "should be true" for: 'true? when: {
    true true? should == true
  }

  it: "should NOT call the block if true" for: 'if_nil: when: {
    true if_nil: { 'is_nil } . should == nil
  }
}
