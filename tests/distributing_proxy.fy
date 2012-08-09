FancySpec describe: DistributingProxy with: {
  it: "forwards messages to each element in turn" when: {
    p = DistributingProxy new: [1,2,3]
    p is: 1
    p is: 2
    p is: 3
    # and again
    p is: 1
    p is: 2
    p is: 3
    # and once more
    p class is: Fixnum
    p inspect is: "2"
    p to_s is: "3"
  }

  it: "waits appropriately if all elements are currently in use" when: {
    p = DistributingProxy new: ["foo", "bar", "baz"]
    results = []
    threads = (1..10) map: |i| {
      Thread new: {
        results << (i, p * 2)
      }
    }
    threads each: @{ join }
    results size is: 10
  }
}