FancySpec describe: Fancy Message with: {
  it: "is a unary message" when: {
    m = Fancy Message new: 'foo
    m unary_message? is: true
    m binary_message? is: false
    m keyword_message? is: false
  }

  it: "is a binary message" when: {
    m = Fancy Message new: '+ with_params: [1, 2]
    m unary_message? is: false
    m binary_message? is: true
    m keyword_message? is: false
  }

  it: "is a keyword message" when: {
    m = Fancy Message new: 'foo:bar: with_params: [1, 2]
    m unary_message? is: false
    m binary_message? is: false
    m keyword_message? is: true
  }
}
