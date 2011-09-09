FancySpec describe: Stack with: {

  it: "creates an empty Stack" with: 'new when: {
    s = Stack new
    s size is: 0
    s empty? is: true
  }

  it: "has a given amount of nil-initialized elements" with: 'new: when: {
    s = Stack new: 5
    s size is: 5
    s each: |x| {
      x nil? is: true
    }
    s empty? is: false
  }

  it: "is empty when created" with: '<< when: {
    s = Stack new
    s empty? is: true
  }

  it: "returns the last inserted element" with: 'pop when: {
    s = Stack new
    s push: 1
    s pop is: 1

    objs = [1,2,3]
    objs each: |x| {
      s push: x
    }

    objs reverse each: |x| {
      s pop is: x
    }
  }

  it: "returns the top of stack element" with: 'top when: {
    s = Stack new
    s top is: nil
    s push: 1
    s top is: 1
    0 upto: 10 do: |x| {
      s push: x
      s top is: x
    }
  }

  it: "returns the amount of elements in the Stack" with: 'size when: {
    s = Stack new
    s size is: 0
    10 times: { s push: 'foo }
    s size is: 10
  }

  it: "returns true if the Stack is empty" with: 'empty? when: {
    s = Stack new
    s empty? is: true
    s push: 1
    s empty? is: false
    s pop
    s empty? is: true

    s = Stack new: 1
    s empty? is: false
  }

  it: "calls a Block with each element, starting with the top of stack" with: 'each: when: {
    s = Stack new
    10 times: |i| { s << i }
    val = 9
    s each: |x| {
      x is: val
      val = val - 1
    }
  }
}
