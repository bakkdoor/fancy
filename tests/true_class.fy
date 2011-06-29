FancySpec describe: TrueClass with: {
  it: "is true for calling and: with non-nil value" with: 'and: when: {
    true and: true . is == true
    true and: 'bar . is == 'bar
  }

  it: "is false for calling and: with a nil value" with: 'and: when: {
    true and: nil . is == nil
  }

  it: "is true for calling && with non-nil value" with: '&& when: {
    (true && true) is == true
    (true && 'bar) is == 'bar
  }

  it: "is false for calling && with a nil value" with: '&& when: {
    (true && nil) is == nil
  }

  it: "is true for calling or: with both non-nil values" with: 'or: when: {
    true or: true . is == true
  }

  it: "is true for calling or: with any values" with: 'or: when: {
    true or: nil . is == true
    true or: true . is == true
    true or: 'foo . is == true
  }

  it: "is true for calling || with both non-nil values" with: '|| when: {
    (true || true) is == true
  }

  it: "is true for calling || with any values" with: '|| when: {
    (true || nil) is == true
    (true || true) is == true
    (true || 'foo) is == true
  }

  it: "calls the then-block" with: 'if_true:else: when: {
    true if_true: { 'then } else: { 'else } . is == 'then
  }

  it: "does not call the block" with: 'if_false: when: {
    true if_false: { 'false } . is == nil
  }

  it: "is not nil" with: 'nil? when: {
    true nil? is == false
  }

  it: "is not false" with: 'false? when: {
    true false? is == false
  }

  it: "is true" with: 'true? when: {
    true true? is == true
  }

  it: "does NOT call the block if true" with: 'if_nil: when: {
    true if_nil: { 'is_nil } . is == nil
  }
}
