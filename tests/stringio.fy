require: "rbx/stringio"

FancySpec describe: StringIO with: {
  before_each: {
    @s = StringIO new
  }

  it: "returns the empty string on initialization" with: 'string when: {
    @s string is: ""
  }

  it: "appends strings to its string value" with: '<< when: {
    @s << "foo"
    @s << "\n"
    @s << "bar"
    @s string is: "foo\nbar"
  }
}