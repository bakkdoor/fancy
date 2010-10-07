def class FancySpec {
  def initialize: description {
    @description = description
    @test_obj = description
    @spec_tests = []
  }

  def initialize: description test_obj: test_obj {
    @description = description
    @test_obj = test_obj
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
    test = SpecTest new: spec_info_string
    test block: spec_block
    @spec_tests << test
  }

  def it: spec_info_string for: method_name when: spec_block {
    test = SpecTest new: spec_info_string
    test block: spec_block
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
}

def class SpecTest {
  @@failed_positive = []
  @@failed_negative = []
  def SpecTest failed_test: actual_and_expected {
    @@failed_positive << actual_and_expected
  }

  def SpecTest failed_negative_test: value {
    @@failed_negative << value
  }

  def initialize: info_str {
    { @@failed_positive = [] } unless: @@failed_positive
    { @@failed_negative = [] } unless: @@failed_negative
    @info_str = info_str
  }

  def block: block {
    @block = block
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
    @@failed_positive size > 0 if_true: {
      any_failure = true
      Console newline
      "> FAILED: " ++ test_obj ++ " " ++ @info_str print
      self print_failed_positive
    }

    @@failed_negative size > 0 if_true: {
      any_failure = true
      Console newline
      "> FAILED: " ++ test_obj ++ " " ++ @info_str print
      self print_failed_negative
    }

    { "." print } unless: any_failure
  }

  def print_failed_positive {
    " [" ++ (@@failed_positive size) ++ " unexpected values]" println
    "Got: " println
    @@failed_positive each: |f| {
      "     " ++ (f first inspect) ++ " instead of: " ++ (f second inspect) println
    }
  }

  def print_failed_negative {
    " [" ++ (@@failed_negative size) ++ " unexpected values]" println
    "Should not have gotten the following values: " println
    @@failed_negative each: |f| {
      "     " ++ (f inspect) println
    }
  }

}

def class PositiveMatcher {
  """PositiveMatcher expects its actual value to be equal to an
     expected value.
     If the values are not equal, a SpecTest failure is generated."""

  def initialize: actual_value {
    @actual_value = actual_value
  }

  def == expected_value {
    @actual_value == expected_value if_false: {
      SpecTest failed_test: [@actual_value, expected_value]
    }
  }

  def != expected_value {
    @actual_value != expected_value if_false: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def unknown_message: msg with_params: params {
    """Forwardy any other message and parameters to the object itself
       and checks the return value."""

    @actual_value send: msg params: params . if_false: {
      SpecTest failed_test: [@actual_value, params first]
    }
  }

  def be: block {
    block call: [@actual_value] . if_false: {
      SpecTest failed_test: [@actual_value, nil]
    }
  }
}

def class NegativeMatcher {
  """NegativeMatcher expects its actual value to be unequal to an
     expected value.
     If the values are equal, a SpecTest failure is generated."""

  def initialize: actual_value {
    @actual_value = actual_value
  }

  def == expected_value {
    @actual_value == expected_value if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def != expected_value {
    @actual_value != expected_value if_true: {
      SpecTest failed_test: [@actual_value, expected_value]
    }
  }

  def unknown_message: msg with_params: params {
    """Forwardy any other message and parameters to the object itself
       and checks the return value."""

    @actual_value send: msg params: params . if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def be: block {
    block call: [@actual_value] . if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }
}

def class Object {
  def should {
    "Returns a PositiveMatcher for self."
    PositiveMatcher new: self
  }

  def should_not {
    "Returns a NegativeMatcher for self."
    NegativeMatcher new: self
  }
}
