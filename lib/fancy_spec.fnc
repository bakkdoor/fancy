def class FancySpec {
  def initialize: test_obj {
    @test_obj = test_obj;
    @spec_tests = []
  };
  
  def self describe: test_obj with: block {
    it = FancySpec new: test_obj;
    block call: [it];
    it run
  };

  def should: spec_info_string when: spec_block {
    test = SpecTest new: spec_info_string;
    test block: spec_block;
    @spec_tests << test
  };

  def run {
    "Running tests for: " ++ @test_obj println;
    @spec_tests each: |test| {
      test run: @test_obj
    };
    Console newline
  }
};

def class SpecTest {
  def self failed_test: actual_and_expected {
    @@failed << actual_and_expected
  };

  def initialize: info_str {
    { @@failed = [] } unless: @@failed;
    @info_str = info_str
  };

  def block: block {
    @block = block
  };

  def run: test_obj {
    @@failed = [];
    @block call;
    (@@failed size > 0) if_true: {
      Console newline;
      "> FAILED: " ++ test_obj ++ " should " ++ @info_str print;
      self print_failed
    } else: {
      "." print
    }
  };

  def print_failed {
    " [" ++ (@@failed size) ++ " unexpected compares]" println;
    "Got: " println;
    @@failed each: |f| {
      "     " ++ (f first) ++ " instead of: " ++ (f second) println
    }
  }
};

def class Object {
  def should_equal: expected_value {
    expected_value is_a?: Block . if_true: {
      expected_value = expected_value call
    };
    self check_with_expected: expected_value
  };

  def check_with_expected: expected_value {
    (self == expected_value) if_false: {
      SpecTest failed_test: [self, expected_value]
    }
  }
}
