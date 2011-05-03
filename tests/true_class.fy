FancySpec describe: TrueClass with: {
  it: "should be true for calling and: with non-nil value" for: 'and: when: {
    true and: true . is == true
    true and: 'bar . is == 'bar
  }

  it: "should be false for calling and: with a nil value" for: 'and: when: {
    true and: nil . is == nil
  }

  it: "should be true for calling && with non-nil value" for: '&& when: {
    (true && true) is == true
    (true && 'bar) is == 'bar
  }

  it: "should be false for calling && with a nil value" for: '&& when: {
    (true && nil) is == nil
  }

  it: "should be true for calling or: with both non-nil values" for: 'or: when: {
    true or: true . is == true
  }

  it: "should be true for calling or: with any values" for: 'or: when: {
    true or: nil . is == true
    true or: true . is == true
    true or: 'foo . is == true
  }

  it: "should be true for calling || with both non-nil values" for: '|| when: {
    (true || true) is == true
  }

  it: "should be true for calling || with any values" for: '|| when: {
    (true || nil) is == true
    (true || true) is == true
    (true || 'foo) is == true
  }

  it: "should call the then-block" for: 'if_true:else: when: {
    true if_true: { 'then } else: { 'else } . is == 'then
  }

  it: "should NOT call the block" for: 'if_false: when: {
    true if_false: { 'false } . is == nil
  }

  it: "should NOT be nil" for: 'nil? when: {
    true nil? is == false
  }

  it: "should NOT be false" for: 'false? when: {
    true false? is == false
  }

  it: "should be true" for: 'true? when: {
    true true? is == true
  }

  it: "should NOT call the block if true" for: 'if_nil: when: {
    true if_nil: { 'is_nil } . is == nil
  }
}
