FancySpec describe: Range with: {
  it: "have the correct amount of elements" for: 'size when: {
    Range new: 1 to: 10 . to_a size should == 10
    (1..10) to_a size should == 10
    ("a".."z") to_a size should == 26
  }

  it: "should have a working literal syntax" when: {
    (1..10) should == (Range new: 1 to: 10)
  }
}
