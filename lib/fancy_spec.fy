class FancySpec {
  """
  The FancySpec class is used for defining FancySpec testsuites.
  Have a look at the tests/ directory to see some examples.
  """

  def initialize: @description test_obj: @test_obj (@description) {
    """
    @description Description @String@ for testcase.
    @test_obj Object to be tested, defaults to @description.
    """

    @spec_tests = []
    @before_blocks = []
    @after_blocks = []
  }

  def FancySpec describe: test_obj with: block {
    """
    Factory method for creating FancySpec instances.
    Calls @block with the new FancySpec instance as the receiver, then runs it.

          FancySpec describe: MyTestClass with: {
            # test cases using it:for:when: here.
          }
    """

    spec = FancySpec new: test_obj
    block call_with_receiver: spec
    spec run
  }

  def FancySpec describe: description for: test_obj with: block {
    """
    Similar to FancySpec##describe:with: but also taking an explicit @test_obj.

          FancySpec describe: \"My cool class\" for: MyCoolClass with: {
            # test cases using it:for:when: here.
          }
    """

    spec = FancySpec new: description test_obj: test_obj
    block call_with_receiver: spec
    spec run
  }

  def it: spec_info_string when: spec_block {
    """
    @spec_info_string Info @String@ related to the test case defined in @spec_block.
    @spec_block @Block@ that holds the testcase's code (including assertions).

    Example:
          it: \"should be an empty Array\" when: {
            arr = [1,2,3]
            3 times: { arr pop }
            arr empty? is == true
          }
    """

    test = SpecTest new: spec_info_string block: spec_block
    @spec_tests << test
  }

  def it: spec_info_string with: method_name when: spec_block {
    """
    @spec_info_string Info @String@ related to the test case defined in @spec_block.
    @method_name Name of Method that this testcase is related to.
    @spec_block @Block@ that holds the testcase's code (including assertions).

    Example:
          it: \"should be an empty Array\" with: 'empty? when: {
            arr = [1,2,3]
            3 times: { arr pop }
            arr empty? is == true
          }
    """

    test = SpecTest new: spec_info_string block: spec_block
    # try {
    #   @test_obj method: method_name . if_true: |method| {
    #     method tests << test
    #   }
    # } catch MethodNotFoundError => e {
    #   # ignore errors
    # }
    @spec_tests << test
  }

  alias_method: 'it:for:when: for: 'it:with:when:

  def before_each: block {
    """
    @block @Block@ to be run before each test case.
    """

    @before_blocks << block
  }

  def after_each: block {
    """
    @block @Block@ to be run after each test case.
    """

    @after_blocks << block
  }

  def run {
    """
    Runs a FancySpec's test cases.
    """

    # "  " ++ @description ++ ": " print
    @spec_tests each: |test| {
      @before_blocks each: |b| {
        b call_with_receiver: test
      }
      test run: @test_obj
      @after_blocks each: |b| {
        b call_with_receiver: test
      }
    }

    # untested_methods = @test_obj methods select: |m| {
    #   m tests size == 0
    # }
    # untested_methods empty? if_false: {
      # ["WARNING: These methods need tests:",
      #  untested_methods map: 'name . select: |m| { m whitespace? not } . join: ", "] println
    # }
  }


  class SpecTest {
    """
    FancySpec test case class.
    """

    read_slot: 'info_str

    @@failed_positive = <[]>
    @@failed_negative = <[]>
    @@failed_count = 0
    @@total_tests = 0
    @@total_expectations = 0

    def SpecTest add_expectation {
      @@total_expectations = @@total_expectations + 1
    }

    def SpecTest failed_test: test {
      """
      @actual_and_expected Pair of actual and expected values for a failed test case.

      Gets called when a SpecTest failed.
      """

      @@failed_positive[@@current_test_obj]: $ @@failed_positive[@@current_test_obj] || { Set new }
      @@failed_positive[@@current_test_obj] << test
      @@failed_count = @@failed_count + 1
    }

    def SpecTest failed_negative_test: test {
      """
      @value Value that should not have occured.

      Gets called when a negative SpecTest (using @NegativeMatcher@) failed.
      """

      @@failed_negative[@@current_test_obj]: $ @@failed_negative[@@current_test_obj] || { Set new }
      @@failed_negative[@@current_test_obj] << test
      @@failed_count = @@failed_count + 1
    }

    def SpecTest current {
      @@current
    }

    def SpecTest print_failures: start_time no_failures: ok_block else: error_block {
      @@failed_positive each: |test_obj failed_tests| {
        failed_tests each: |t| {
          Console newline
          "> FAILED: " ++ test_obj ++ " " ++ (t info_str) print
          t print_failed_positive
        }
      }

      @@failed_negative each: |test_obj failed_tests| {
        failed_tests each: |t| {
          Console newline
          "> FAILED: " ++ test_obj ++ " " ++ (t info_str) print
          t print_failed_negative
        }
      }

      Console newline
      "Ran #{@@total_tests} tests (#{@@total_expectations} expectations) with #{@@failed_count} failures in #{Time now - start_time} seconds." println
      if: (@@failed_count == 0) then: ok_block else: error_block
    }

    def initialize: @info_str block: @block {
      { @@failed_positive = <[]> } unless: @@failed_positive
      { @@failed_negative = <[]> } unless: @@failed_negative
      @failed_positive = []
      @failed_negative = []
    }

    def run: test_obj {
      @@current_test_obj = test_obj
      @@current = self
      @@total_tests = @@total_tests + 1
      try {
        @block call_with_receiver: self
      } catch StandardError => e {
        failed: (e, "No Exception") location: (e backtrace)
      }

      if: failed? then: {
        "f" print
      } else: {
        "." print
      }
    }

    def failed: actual_and_expected location: location (nil) {
      unless: location do: {
        location = caller() find: |l| { l =~ /__script__/ }
      }
      @failed_positive << (actual_and_expected, location)
      SpecTest failed_test: self
    }

    def failed_negative: value {
      { value = [value, 'negative_failure] } unless: $ value responds_to?: 'at:
      location = caller() find: |l| { l =~ /__script__/ }
      @failed_negative << (value, location)
      SpecTest failed_negative_test: self
    }

    def failed? {
      @failed_positive empty? not || { @failed_negative empty? not }
    }


    def print_failed_positive {
      " [" ++ (@failed_positive size) ++ " unexpected values]" println
      print_failed_common: @failed_positive
    }

    def print_failed_negative {
      " [" ++ (@failed_negative size) ++ " unexpected values]" println
      "Should not have gotten the following values: " println
      print_failed_common: @failed_negative
    }

    def print_failed_common: failures {
      failures each: |f| {
        actual, expected = f first
        locations = f second

        locations to_a map: |loc| {
          loc = loc gsub(/:(\d+):in `[^']+'/, " +\1")
          file, line = loc split: " +"
          loc = "#{file} +#{line to_i - 1}" # somehow line is off by +1
          loc = loc split: (Directory pwd + "/") . second
        } . compact println

        unless: (expected == 'negative_failure) do: {
          "    Expected: #{expected inspect}" println
          "    Received: #{actual inspect}" println
        } else: {
          "    " ++ (actual inspect) println
        }
      }
    }
  }

  class PositiveMatcher {
    """
    PositiveMatcher expects its actual value to be equal to an
    expected value.
    If the values are not equal, a SpecTest failure is generated.
    """

    def initialize: @actual_value {
      SpecTest add_expectation
    }

    def == expected_value {
      unless: (@actual_value == expected_value) do: {
        SpecTest current failed: (@actual_value, expected_value)
      }
    }

    def != expected_value {
      unless: (@actual_value != expected_value) do: {
        SpecTest current failed_negative: (@actual_value, expected_value)
      }
    }

    def raise: exception_class {
      try {
        @actual_value call
        # make sure we raise an exception.
        # if no exepction raised at this point, we have an error.
        SpecTest current failed: (nil, exception_class)
      } catch exception_class {
        # ok
      } catch StandardError => e {
        SpecTest current failed: (e class, exception_class)
      }
    }

    def raise: exception_class with: block {
      try {
        @actual_value call
        # same here
        SpecTest current failed: (nil, exception_class)
      } catch exception_class => e {
        block call: [e]
        # ok
      } catch StandardError => e {
        SpecTest current failed: (e class, exception_class)
      }
    }

    def unknown_message: msg with_params: params {
      """
      Forwards any other message and parameters to the object itself
      and checks the return value.
      """

      unless: (@actual_value receive_message: msg with_params: params) do: {
        SpecTest current failed: (@actual_value, params first)
      }
    }

    def be: block {
      unless: (block call: [@actual_value]) do: {
        SpecTest current failed: (@actual_value, nil)
      }
    }
  }

  class NegativeMatcher {
    """
    NegativeMatcher expects its actual value to be unequal to an
    expected value.
    If the values are equal, a SpecTest failure is generated.
    """

    def initialize: @actual_value {
      SpecTest add_expectation
    }

    def == expected_value {
      if: (@actual_value == expected_value) then: {
        SpecTest current failed_negative: @actual_value
      }
    }

    def != expected_value {
      if: (@actual_value != expected_value) then: {
        SpecTest current failed: (@actual_value, expected_value)
      }
    }

    def raise: exception_class {
      try {
        @actual_value call
      } catch exception_class {
        SpecTest current failed_negative: (exception_class, nil)
      } catch StandardError => e {
        true
        # ok
      }
    }

    def unknown_message: msg with_params: params {
      """
      Forwards any other message and parameters to the object itself
      and checks the return value.
      """

      if: (@actual_value receive_message: msg with_params: params) then: {
        SpecTest current failed_negative: @actual_value
      }
    }

    def be: block {
      if: (block call: [@actual_value]) then: {
        SpecTest current failed_negative: @actual_value
      }
    }
  }
}

class Object {
  def should {
    """
    Returns a @PositiveMatcher@ for self.
    """

    FancySpec PositiveMatcher new: self
  }

  alias_method: 'is for: 'should
  alias_method: 'does for: 'should

  def is: expected {
    is == expected
  }

  def is_not: expected {
    does_not == expected
  }

  def should_not {
    """
    Returns a @NegativeMatcher@ for self.
    """

    FancySpec NegativeMatcher new: self
  }

  alias_method: 'is_not for: 'should_not
  alias_method: 'does_not for: 'should_not
}

class Block {
  def raises: exception_class {
    FancySpec PositiveMatcher new: self . raise: exception_class
  }

  def raises: exception_class with: block {
    FancySpec PositiveMatcher new: self . raise: exception_class with: block
  }
}