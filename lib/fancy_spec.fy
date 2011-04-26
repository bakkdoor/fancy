class FancySpec {
  """
  The FancySpec class is used for defining FancySpec testsuites.
  Have a look at the tests/ directory to see some examples.
  """


  def initialize: @description test_obj: @test_obj (@description) {
    @spec_tests = []
  }

  def FancySpec describe: test_obj with: block {
    spec = FancySpec new: test_obj
    block call_with_receiver: spec
    spec run
  }

  def FancySpec describe: description for: test_obj with: block {
    spec = FancySpec new: description test_obj: test_obj
    block call_with_receiver: spec
    spec run
  }

  def it: spec_info_string when: spec_block {
    test = SpecTest new: spec_info_string block: spec_block
    @spec_tests << test
  }

  def it: spec_info_string for: method_name when: spec_block {
    test = SpecTest new: spec_info_string block: spec_block
    # try {
    #   @test_obj method: method_name . if_do: |method| {
    #     method tests << test
    #   }
    # } catch MethodNotFoundError => e {
    #   # ignore errors
    # }
    @spec_tests << test
  }

  def run {
    "Running tests for: " ++ @description ++ ": " print
    @spec_tests each: |test| {
      test run: @test_obj
    }
#    Console newline Console newline
    # untested_methods = @test_obj methods select: |m| {
    #   m tests size == 0
    # }
    # untested_methods empty? if_false: {
      # ["WARNING: These methods need tests:",
      #  untested_methods map: 'name . select: |m| { m whitespace? not } . join: ", "] println
    # }
    Console newline
  }


  class SpecTest {
    @@failed_positive = []
    @@failed_negative = []

    def SpecTest failed_test: actual_and_expected {
      @@failed_positive << [actual_and_expected, caller(6) at: 0]
    }

    def SpecTest failed_negative_test: value {
      @@failed_negative << [value, caller(6) at: 0]
    }

    def initialize: @info_str block: @block {
      { @@failed_positive = [] } unless: @@failed_positive
      { @@failed_negative = [] } unless: @@failed_negative
    }

    def run: test_obj {
      @@failed_positive = []
      @@failed_negative = []
      try {
        @block call
      } catch IOError => e {
        SpecTest failed_test: [e, "UNKNOWN"]
      }

      any_failure = nil
      if: (@@failed_positive size > 0) then: {
        any_failure = true
        Console newline
        "> FAILED: " ++ test_obj ++ " " ++ @info_str print
        print_failed_positive
      }

      if: (@@failed_negative size > 0) then: {
        any_failure = true
        Console newline
        "> FAILED: " ++ test_obj ++ " " ++ @info_str print
        print_failed_negative
      }

      { "." print } unless: any_failure
    }

    def print_failed_positive {
      " [" ++ (@@failed_positive size) ++ " unexpected values]" println
      "Got: " println
      print_failed_common: @@failed_positive
    }

    def print_failed_negative {
      " [" ++ (@@failed_negative size) ++ " unexpected values]" println
      "Should not have gotten the following values: " println
      print_failed_common: @@failed_negative
    }

    def print_failed_common: failures {
      failures each: |f| {
        actual, expected = f first
        location = f second gsub(/:(\d+):in `[^']+'/, ":\1")
        location = location split: "/" . from: -2 to: -1 . join: "/"

        "    Location: #{location}" println
        "    Expected: #{expected inspect}" println
        "    Received: #{actual inspect}" println
      }
    }
  }

  class PositiveMatcher {
    """PositiveMatcher expects its actual value to be equal to an
       expected value.
       If the values are not equal, a SpecTest failure is generated."""

    def initialize: @actual_value {
    }

    def == expected_value {
      unless: (@actual_value == expected_value) do: {
        SpecTest failed_test: [@actual_value, expected_value]
      }
    }

    def != expected_value {
      unless: (@actual_value != expected_value) do: {
        SpecTest failed_negative_test: [@actual_value, expected_value]
      }
    }

    def raise: exception_class {
      try {
        @actual_value call
      } catch exception_class {
        # ok
      } catch Exception => e {
        SpecTest failed_test: [e class, exception_class]
      }
    }

    def unknown_message: msg with_params: params {
      """Forwardy any other message and parameters to the object itself
         and checks the return value."""

      unless: (@actual_value send_message: msg with_params: params) do: {
        SpecTest failed_test: [@actual_value, params first]
      }
    }

    def be: block {
      unless: (block call: [@actual_value]) do: {
        SpecTest failed_test: [@actual_value, nil]
      }
    }
  }

  class NegativeMatcher {
    """NegativeMatcher expects its actual value to be unequal to an
       expected value.
       If the values are equal, a SpecTest failure is generated."""

    def initialize: @actual_value {
    }

    def == expected_value {
      if: (@actual_value == expected_value) then: {
        SpecTest failed_negative_test: @actual_value
      }
    }

    def != expected_value {
      if: (@actual_value != expected_value) then: {
        SpecTest failed_test: [@actual_value, expected_value]
      }
    }

    def raise: exception_class {
      try {
        @actual_value call
      } catch exception_class {
        SpecTest failed_negative_test: [exception_class, nil]
      } catch Exception => e {
        true
        # ok
      }
    }

    def unknown_message: msg with_params: params {
      """Forwardy any other message and parameters to the object itself
         and checks the return value."""

      if: (@actual_value send_message: msg with_params: params) then: {
        SpecTest failed_negative_test: @actual_value
      }
    }

    def be: block {
      if: (block call: [@actual_value]) then: {
        SpecTest failed_negative_test: @actual_value
      }
    }
  }
}

class Object {
  def should {
    "Returns a PositiveMatcher for self."
    FancySpec PositiveMatcher new: self
  }

  def should_not {
    "Returns a NegativeMatcher for self."
    FancySpec NegativeMatcher new: self
  }
}
