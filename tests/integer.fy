FancySpec describe: Integer with: {
  it: "returns its decimals as an array" with: 'decimals when: {
    (0..9) each: |i| { i decimals is: [i] }
    10 decimals is: [1, 0]
    100 decimals is: [1, 0, 0]
    123 decimals is: [1, 2, 3]
    998811 decimals is: [9, 9, 8, 8, 1, 1]
    -0 decimals is: [0]
    -10 decimals is: [1,0]
    -1234 decimals is: [1, 2, 3, 4]
  }
}