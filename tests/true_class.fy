FancySpec describe: TrueClass with: {
  it: "is true for calling and: with non-nil value" for: 'and: when: {
    true and: true . is == true
    true and: 'bar . is == 'bar
  }

  it: "is false for calling and: with a nil value" for: 'and: when: {
    true and: nil . is == nil
  }

  it: "is true for calling && with non-nil value" for: '&& when: {
    (true && true) is == true
    (true && 'bar) is == 'bar
  }

  it: "is false for calling && with a nil value" for: '&& when: {
    (true && nil) is == nil
  }

  it: "is true for calling or: with both non-nil values" for: 'or: when: {
    true or: true . is == true
  }

  it: "is true for calling or: with any values" for: 'or: when: {
    true or: nil . is == true
    true or: true . is == true
    true or: 'foo . is == true
  }

  it: "is true for calling || with both non-nil values" for: '|| when: {
    (true || true) is == true
  }

  it: "is true for calling || with any values" for: '|| when: {
    (true || nil) is == true
    (true || true) is == true
    (true || 'foo) is == true
  }

  it: "calls the then-block" for: 'if_true:else: when: {
    true if_true: { 'then } else: { 'else } . is == 'then
  }

  it: "does not call the block" for: 'if_false: when: {
    true if_false: { 'false } . is == nil
  }

  it: "is not nil" for: 'nil? when: {
    true nil? is == false
  }

  it: "is not false" for: 'false? when: {
    true false? is == false
  }

  it: "is true" for: 'true? when: {
    true true? is == true
  }

  it: "does NOT call the block if true" for: 'if_nil: when: {
    true if_nil: { 'is_nil } . is == nil
  }
}
