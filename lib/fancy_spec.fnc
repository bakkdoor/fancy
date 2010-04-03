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
    "Running tests for: " print;
    @test_obj println;
    @spec_tests each: |test| {
      test run
    }
  }
};

def class SpecTest {
  def self failed_test {
    @@failed = @@failed + 1
  };

  def initialize: info_str {
    { @@failed = 0 } unless: @@failed;
    @info_str = info_str
  };

  def block: block {
    @block = block
  };

  def run {
    @@failed = 0;
    @block call;
    (@@failed > 0) if_true: {
      " > FAILED: It should " print;
      @info_str print;
      self print_failed
    } else: {
      " > PASSED: It should " print;
      @info_str println
    }
  };

  def print_failed {
    " [" print;
    @@failed print;
    " unexpected compares" print;
    "]" println
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
      SpecTest failed_test
    }
  }
}
