require: "lib/option_parser"

FancySpec describe: OptionParser with: {
  it: "parses an option with no argument" when: {
    parsed_option? = false

    o = OptionParser new: @{
      with: "--test" doc: "Do something" do: {
        parsed_option? = true
      }
    }

    parsed_option? is: false
    o parse: ["foo", "bar", "--test", "baz"]
    parsed_option? is: true
  }

  it: "parses no option if none are passed" when: {
    parsed_option? = false
    o = OptionParser new: @{
      with: "--foo [arg]" doc: "bla" do: |arg| {
        parsed_option? = true
      }
      with: "--bar" doc: "more bla" do: {
        parsed_option? = true
      }
    }

    parsed_option? is: false
    o parse: ["hello", "foo", "bar", "no expected options given!"]
    parsed_option? is: false
  }

  it: "parses an option with an argument" when: {
    parsed_option? = false
    passed_args = []

    o = OptionParser new: @{
      with: "--my-val [arg]" doc: "gimme an argument!" do: |arg| {
        parsed_option? = true
        passed_args << (arg to_i)
      }
      with: "--my-other-val [arg]" doc: "gimme another argument!" do: |arg| {
        parsed_option? = true
        passed_args << (arg to_s * 2)
      }
    }

    parsed_option? is: false
    passed_args is: []
    o parse: ["foo", "1", "2", "bar", "--my-val", "42", "and", "--my-other-val", "42", "some", "more"]
    parsed_option? is: true
    passed_args size is: 2
    passed_args includes?: 42 . is: true
    passed_args includes?: "4242" . is: true
    o parsed_options is: <["--my-val" => "42", "--my-other-val" => "42"]>
  }

  it: "always prints the banner and --help message" with: 'print_help_info when: {
    o = OptionParser new: @{
      banner: "My Banner, yo"
    }
    out = StringIO new
    let: '*stdout* be: out in: {
      o print_help_info
      out string is: "My Banner, yo\n\n  --help  Display this information\n"
    }
  }
}
