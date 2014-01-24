class OptionParser {
  """
  Parses command-line options from a given @Array@ (usually @ARGV) and
  executes registered handlers for options specified.
  """

  class Option {
    read_slots: ('option, 'arg, 'doc_string, 'block)
    def initialize: @option arg: @arg doc: @doc_string block: @block
    def name_with_arg {
      if: @arg then: {
        "#{@option} [#{@arg}]"
      } else: {
        @option
      }
    }
  }

  class InvalidOptionsError : StandardError

  read_slots: ('options, 'parsed_options)
  read_write_slots: ('banner, 'exit_on_help, 'remove_after_parsed)

  def initialize: @block (nil) {
    """
    @block (Optional) @Block@ to be called with @self for easy setup.

    Creates a new OptionParser.

    Example:

          o = OptionParser new: @{
            with: \"--my-option\" doc: \"Sets some option value\" do: {
              # do stuff in here...
            }
          }
          o parse: ARGV # parse options from ARGV
    """

    @options = <[]>
    @parsed_options = <[]>
    @banner = nil
    @exit_on_help = true
    @remove_after_parsed = false

    with: "--help" doc: "Display this information" do: {
      print_help_info
      { System exit } if: @exit_on_help
    }

    { @block call: [self] } if: @block
  }

  def with: option_string doc: doc_string do: block ('identity) {
    """
    @option_string Option flag and (optional) argument within \"[]\", e.g. \"--file [filename]\".
    @doc_string Documentation @String@ for @option_string that is used in the standard @--help option.
    @block @Block@ to be executed if @option_string is matched during parsing. If the option takes an argument it will be passed to @block as an argument.

    Example:

          o = OptionParser new
          o with: \"--file [filename]\" doc: \"Use this file for processing\" do: |filename| {
            # do something with filename
          }
    """

    option, arg = option_string split: " "
    if: arg then: {
      match arg {
        case /\[(.+)\]/ -> |_, arg_name|
          arg = arg_name downcase
        case _ -> InvalidOptionsError new: "Could not correctly parse option argument: #{arg}" . raise!
      }
    }

    o = Option new: option arg: arg doc: doc_string block: block
    @options[option]: o
  }

  def parse: args {
    """
    @args @Array@ of arguments to parse options from. Typically you'd pass @ARGV here.

    Parses options from @args and executes registered option handlers.
    """

    @options each: |name opt| {
      if: (args index: name) then: |idx| {
        block = opt block
        match block arity {
          case 0 -> block call
          case 1 ->
            arg = args at: (idx + 1)
            block call: [arg]
            @parsed_options[name]: arg
            { args remove_at: idx } if: @remove_after_parsed
        }

        { args remove_at: idx } if: @remove_after_parsed
      }
    }
  }

  def parse_hash: args {
    """
    @args @Array@ of arguments to parse options from. Typically you'd pass @ARGV here.

    Parses options as @Hash@ from @args and executes registered option handlers.

    Example:

          o = OptionParser new: @{
            with: \"--some-option [option_value]\" doc: \"some docstring\"
            # ...
          }
          opts = o parse_hash: [\"--some-option\", \"some-value\"]
          opts # => <[\"--some-option\" => \"some-value\"]>
    """

    parse: args
    parsed_options
  }

  def print_help_info {
    """
    Displays the @--help information on @*stdout* based on all options that
    were registered via @OptionParser#with:doc:do:@.
    """

    max_size = @options map: |name opt| { opt name_with_arg size } . max
    if: @banner then: {
      *stdout* println: @banner
      *stdout* println
    }
    @options keys sort each: |name| {
      opt = @options[name]
      *stdout* printf("  %-#{max_size}s  %s\n", opt name_with_arg, opt doc_string)
    }
  }
}
