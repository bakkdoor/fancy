FancySpec describe: "Boolean value" with: |it| {
  it should: "be true for calling and: with both non-nil values" when: {
    true and: true . should_equal: true;
    :foo and: :bar . should_equal: true
  };

  it should: "be false for calling and: with a nil value" when: {
    true and: nil . should_equal: nil;
    nil and: true . should_equal: nil;
    :foo and: nil . should_equal: nil
  };

  it should: "be true for calling or: with both non-nil values" when: {
    true or: true . should_equal: true
  };
  
  it should: "be true for calling or: with one non-nil values" when: {
    true or: nil . should_equal: true;
    nil or: true . should_equal: true
  };

  it should: "be false for calling or: with both nil values" when: {
    nil or: nil . should_equal: nil
  };

  it should: "call the then-block for a non-nil value" when: {
    true if_true: { :then } else: { :else } . should_equal: :then
  };

  it should: "call the block for a non-nil value" when: {
    true if_true: { :then } . should_equal: :then
  };

  it should: "NOT call the block for a nil value" when: {
    nil if_true: { :then } . should_equal: nil
  };

  it should: "NOT call the block for a non-nil value" when: {
    true if_false: { :false } . should_equal: nil
  };

  it should: "call the block for a nil value" when: {
    nil if_false: { :false } . should_equal: :false
  };

  it should: "NOT be nil for non-nil values" when: {
    true nil? should_equal: nil;
    :foo nil? should_equal: nil
  };

  it should: "be nil for nil values" when: {
    nil nil? should_equal: true
  };

  it should: "NOT be false for non-nil values" when: {
    true false? should_equal: nil;
    :foo false? should_equal: nil;
    "hello, world" false? should_equal: nil
  };

  it should: "only be true for true" when: {
    true true? should_equal: true;
    :foo true? should_equal: nil;
    "hello, world" true? should_equal: nil;
    nil true? should_equal: nil
  };
  
  it should: "be false for nil values" when: {
    nil false? should_equal: true
  };

  it should: "call the block if nil" when: {
    nil if_nil: { :is_nil } . should_equal: :is_nil
  };

  it should: "NOT call the block if not nil" when: {
    true if_nil: { :is_nil } . should_equal: nil;
    :foo if_nil: { :is_nil } . should_equal: nil;
    "hello, world" if_nil: { :is_nil } . should_equal: nil
  }
}
