TestModuleTopLevelConstant = true
class TestModuleConstant {
  Constant = true
  class Nested {
    Constant = true
  }
}
TestModuleConstantMultiA, TestModuleConstantMultiB = 1, 2

FancySpec describe: Module with: {
  it: "preserves method documentation when dynamically overwriting" \
  with: 'overwrite_method:with_dynamic: when: {
    class Bar {
      def foo {
        "bar"
      }
    }
    # Check it's as expected before overwriting.
    Bar instance_method: 'foo . documentation to_s is: "bar"
    class Bar {
      overwrite_method: 'foo with_dynamic: |g| {
        g push_literal("bar")
        g ret()
      }
    }
    # Make sure it's preserved
    Bar instance_method: 'foo . documentation to_s is: "bar"
  }#/preserve method documentation
  
  it: "gets constants" when: {
    TestModuleTopLevelConstant is_not: nil
    TestModuleConstant Constant is: true
    TestModuleConstant Nested Constant is: true
  }
  it: "sets top-level constants" when: {
    TestModuleTopLevelConstant is_not: 'other
    TestModuleTopLevelConstant = 'other
    TestModuleTopLevelConstant is: 'other
  }
  it: "multiple-assigns constants" when: {
    TestModuleConstantMultiA is: 1
    TestModuleConstantMultiB is: 2
  }

}#/Module
