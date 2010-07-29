def class FancySpec {
  def initialize: test_obj {
    @test_obj = test_obj;
    @spec_tests = []
  }

  def self describe: test_obj with: block {
    it = FancySpec new: test_obj;
    block call: [it];
    it run
  }

  def should: spec_info_string when: spec_block {
    test = SpecTest new: spec_info_string;
    test block: spec_block;
    @spec_tests << test
  }

  def run {
    "Running tests for: " ++ @test_obj ++ ": " print;
    @spec_tests each: |test| {
      test run: @test_obj
    };
    Console newline
  }
};

def class SpecTest {
  def self failed_test: actual_and_expected {
    @@failed_positive << actual_and_expected
  }

  def self failed_negative_test: value {
    @@failed_negative << value
  }

  def initialize: info_str {
    { @@failed_positive = [] } unless: @@failed_positive;
    { @@failed_negative = [] } unless: @@failed_negative;
    @info_str = info_str
  }

  def block: block {
    @block = block
  }

  def run: test_obj {
    @@failed_positive = [];
    @@failed_negative = [];
    try {
      @block call
    } catch IOError => e {
      SpecTest failed_test: [e, "UNKNOWN"]
    };

    (@@failed_positive size > 0) if_true: {
      Console newline;
      "> FAILED: " ++ test_obj ++ " should " ++ @info_str print;
      self print_failed_positive
    } else: {
      "." print
    };

    (@@failed_negative size > 0) if_true: {
      Console newline;
      "> FAILED: " ++ test_obj ++ " should " ++ @info_str print;
      self print_failed_negative
    } else: {
      "." print
    }
  }

  def print_failed_positive {
    " [" ++ (@@failed_positive size) ++ " unexpected values]" println;
    "Got: " println;
    @@failed_positive each: |f| {
      "     " ++ (f first inspect) ++ " instead of: " ++ (f second inspect) println
    }
  }

  def print_failed_negative {
    " [" ++ (@@failed_negative size) ++ " unexpected values]" println;
    "Should not have gotten the following values: " println;
    @@failed_negative each: |f| {
      "     " ++ (f inspect) println
    }
  }

};

def class PositiveMatcher {
  def initialize: expected_value {
    @actual_value = expected_value
  }

  def == expected_value {
    (@actual_value == expected_value) if_false: {
      SpecTest failed_test: [@actual_value, expected_value]
    }
  }

  def != expected_value {
    (@actual_value != expected_value) if_false: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def unknown_message: msg with_params: params {
    """Forwardy any other message and parameters to the object itself
       and checks the return value.""";

    (@actual_value send: msg params: params) if_false: {
      SpecTest failed_test: [@actual_value, params first]
    }
  }

  def be: block {
    (block call: [@actual_value]) if_false: {
      SpecTest failed_test: [@actual_value, nil]
    }
  }
};

def class NegativeMatcher {
  def initialize: actual_value {
    @actual_value = actual_value
  }

  def == expected_value {
    (@actual_value == expected_value) if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def != expected_value {
    (@actual_value != expected_value) if_true: {
      SpecTest failed_test: [@actual_value, expected_value]
    }
  }

  def unknown_message: msg with_params: params {
    """Forwardy any other message and parameters to the object itself
       and checks the return value.""";

    (@actual_value send: msg params: params) if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }

  def be: block {
    (block call: [@actual_value]) if_true: {
      SpecTest failed_negative_test: @actual_value
    }
  }
};

def class Object {
  def should {
    PositiveMatcher new: self
  }

  def should_not {
    NegativeMatcher new: self
  }
}
