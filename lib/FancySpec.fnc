def class FancySpec {
  def FancySpec describe: class_obj with: block {
    it = FancySpec new;
    define_methods_for: class_obj;
    block call
  };

  def define_methods_for: class_obj {
    class_obj define_method: "should_equal:" with: |expected_value| {
      expected_value is_a?: Block . if_true: {
        expected_value = expected_value call;
      };
      self check_with_expected: expected_value
    };

    class_obj define_method: "check_with_expected:" with: |expected_value| {
      real_value == expected_value . if_true: {
        "PASSED: " print;
        @info_str println
      } else: {
        "FAILED: " print;
        @info_str println
      }
    }
  }

  def should: spec_info_string when: spec_block {
    @info_str = spec_info_string;
    @spec_block = spec_block
  }
}
