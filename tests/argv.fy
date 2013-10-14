FancySpec describe: "ARGV & predefined values" with: {
  it: "has ARGV correctly defined" when: {
    ARGV empty? is_not: true
  }

  it: "has a __FILE__ variable defined" when: {
    __FILE__ is_not: nil
    __FILE__ does =~ /\/argv.fy$/
  }

  it: "has a __LINE__ variable defined" when: {
    __LINE__ is_not: nil
    __LINE__ is: 13
  }

  it: "has a __DIR__ variable defined" when: {
    __DIR__ is_not: nil
    __DIR__ does =~ /fancy\/tests$/
  }
}
