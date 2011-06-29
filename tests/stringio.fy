require: "rbx/stringio"

FancySpec describe: StringIO with: {
  before_each: {
    @s = StringIO new
  }
  it: "returns the empty string on initialization" for: 'string when: {
    @s string == ""
  }

  it: "appends strings to its string value" for: '<< when: {
    @s << "foo"
    @s << "\n"
    @s << "bar"
    @s string is == "foo\nbar"
  }
}