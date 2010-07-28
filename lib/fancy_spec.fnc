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
      SpecTest failed_negative_test: [@actual_value, expected_value]
    }
  }

  def be: block {
    (block call: [@actual_value]) if_false: {
      SpecTest failed_negative_test: [@actual_value, nil]
    }
  }
};

def class NegativeMatcher {
  def initialize: actual_value {
    @actual_value = actual_value
  }

  def == expected_value {
    (@actual_value == expected_value) if_true: {
      SpecTest failed_test: [@actual_value, expected_value]
    }
  }

  def != expected_value {
    (@actual_value != expected_value) if_true: {
      SpecTest failed_negative_test: [@actual_value, expected_value]
    }
  }

  def be: block {
    (block call: [@actual_value]) if_true: {
      SpecTest failed_negative_test: [@actual_value, nil]
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
