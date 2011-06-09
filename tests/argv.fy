FancySpec describe: "ARGV & predefined values" with: {
  it: "should have ARGV correctly defined" when: {
    ARGV empty? should_not == true
  }

  it: "should have a __FILE__ variable defined" when: {
    __FILE__ should_not == nil
    __FILE__ is =~ /\/argv.fy$/
  }
}
