FancySpec describe: Regexp with: {
  it: "returns true if it matches a string" with: 'matches?: when: {
    /foo/ matches?: "hello foo bar" . is: true
    /foo/ matches?: "hello fob bar" . is: false
  }
}
