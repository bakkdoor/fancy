FancySpec describe: "ARGV & predefined values" with: {
  it: "has ARGV correctly defined" when: {
    ARGV empty? is_not == true
  }

  it: "has a __FILE__ variable defined" when: {
    __FILE__ is_not == nil
    __FILE__ is =~ /\/argv.fy$/
  }
}
