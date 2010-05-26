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
    @@failed << actual_and_expected
  }

  def initialize: info_str {
    { @@failed = [] } unless: @@failed;
    @info_str = info_str
  }

  def block: block {
    @block = block
  }

  def run: test_obj {
    @@failed = [];
    try {
      @block call
    } catch IOError => e {
      SpecTest failed_test: [e, "UNKNOWN"]
    };

    (@@failed size > 0) if_true: {
      Console newline;
      "> FAILED: " ++ test_obj ++ " should " ++ @info_str print;
      self print_failed
    } else: {
      "." print
    }
  }

  def print_failed {
    " [" ++ (@@failed size) ++ " unexpected values]" println;
    "Got: " println;
    @@failed each: |f| {
      "     " ++ (f first inspect) ++ " instead of: " ++ (f second inspect) println
    }
  }
};

def class Object {
  def should_equal: expected_value {
    expected_value is_a?: Block . if_true: {
      expected_value = expected_value call
    };
    self check_with_expected: expected_value
  }

  def should_not_equal: unexpected_value {
    unexpected_value is_a?: Block . if_true: {
      unexpected_value = unexpected_value call
    };
    self check_with_unexpected: unexpected_value
  }
  
  def should_be: block {
    (block call: [self]) if_false: {
      SpecTest failed_test: [self, nil]
    }
  }
  
  def should_not_be: block {
    (block call: [self]) if_true: {
      SpecTest failed_test: [self, nil]
    }
  }

  def check_with_expected: expected_value {
    (self == expected_value) if_false: {
      SpecTest failed_test: [self, expected_value]
    }
  }

  def check_with_unexpected: unexpected_value {
    (self != unexpected_value) if_false: {
      SpecTest failed_test: [self, unexpected_value]
    }
  }
}
