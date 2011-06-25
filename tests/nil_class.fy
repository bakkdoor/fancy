FancySpec describe: NilClass with: {
  it: "is false for calling and: with any value" for: 'and: when: {
    nil and: true . is == nil
    nil and: 'foo . is == nil
    nil and: nil . is == nil
    false and: true . is == false
    false and: 'foo . is == false
    false and: nil . is == false
  }

  it: "is nil/false for calling && with any value" for: '&& when: {
    (nil && true) is == nil
    (nil && 'foo) is == nil
    (nil && nil) is == nil
    (false && true) is == false
    (false && 'foo) is == false
    (false && nil) is == false
  }

  it: "is true for calling or: with any non-nil value" for: 'or: when: {
    nil or: true . is == true
    nil or: 'foo . is == 'foo
  }

  it: "is nil/false for calling or: with a nil/false value" for: 'or: when: {
    nil or: nil . is == nil
    nil or: false . is == false
  }

  it: "is true for calling || with any non-nil value" for: '|| when: {
    (nil || true) is == true
    (nil || 'foo) is == 'foo
  }

  it: "is nil for calling || with a nil value" for: '|| when: {
    (nil || nil) is == nil
  }

  it: "does not call the block" for: 'if_true: when: {
    nil if_true: { 'then } . is == nil
  }

  it: "does not call the block" for: 'if_false: when: {
    nil if_false: { 'false } . is == nil
  }

  it: "is nil" for: 'nil? when: {
    nil nil? is == true
  }

  it: "is false" for: 'false? when: {
    nil false? is == false
  }

  it: "is not true" for: 'true? when: {
    nil true? is == false
  }

  it: "calls the block if nil" for: 'if_nil: when: {
    nil if_nil: { 'is_nil } . is == 'is_nil
  }
}
