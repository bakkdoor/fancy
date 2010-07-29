FancySpec describe: "Boolean value" with: |it| {
  it should: "be true for calling and: with both non-nil values" when: {
    true and: true . should == true;
    :foo and: :bar . should == true
  };

  it should: "be false for calling and: with a nil value" when: {
    true and: nil . should == nil;
    nil and: true . should == nil;
    :foo and: nil . should == nil
  };

  it should: "be true for calling or: with both non-nil values" when: {
    true or: true . should == true
  };

  it should: "be true for calling or: with one non-nil values" when: {
    true or: nil . should == true;
    nil or: true . should == true
  };

  it should: "be false for calling or: with both nil values" when: {
    nil or: nil . should == nil
  };

  it should: "call the then-block for a non-nil value" when: {
    true if_true: { :then } else: { :else } . should == :then
  };

  it should: "call the block for a non-nil value" when: {
    true if_true: { :then } . should == :then
  };

  it should: "NOT call the block for a nil value" when: {
    nil if_true: { :then } . should == nil
  };

  it should: "NOT call the block for a non-nil value" when: {
    true if_false: { :false } . should == nil
  };

  it should: "call the block for a nil value" when: {
    nil if_false: { :false } . should == :false
  };

  it should: "NOT be nil for non-nil values" when: {
    true nil? should == nil;
    :foo nil? should == nil
  };

  it should: "be nil for nil values" when: {
    nil nil? should == true
  };

  it should: "NOT be false for non-nil values" when: {
    true false? should == nil;
    :foo false? should == nil;
    "hello, world" false? should == nil
  };

  it should: "only be true for true" when: {
    true true? should == true;
    :foo true? should == nil;
    "hello, world" true? should == nil;
    nil true? should == nil
  };

  it should: "be false for nil values" when: {
    nil false? should == true
  };

  it should: "call the block if nil" when: {
    nil if_nil: { :is_nil } . should == :is_nil
  };

  it should: "NOT call the block if not nil" when: {
    true if_nil: { :is_nil } . should == nil;
    :foo if_nil: { :is_nil } . should == nil;
    "hello, world" if_nil: { :is_nil } . should == nil
  }
}
