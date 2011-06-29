FancySpec describe: Stack with: {
  it: "is empty when created" with: '<< when: {
    s = Stack new
    s empty? is == true
  }

  it: "returns the last inserted element" with: 'pop when: {
    s = Stack new
    s push: 1
    s pop is == 1

    objs = [1,2,3]
    objs each: |x| {
      s push: x
    }

    objs reverse each: |x| {
      s pop is == x
    }
  }

  it: "calls a Block with each element, starting with the top of stack" with: 'each: when: {
    s = Stack new
    10 times: |i| { s << i }
    val = 9
    s each: |x| {
      x is == val
      val = val - 1
    }
  }
}
