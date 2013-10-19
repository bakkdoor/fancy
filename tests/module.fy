# Used in top-level module constant and nested constast tests.
TestModuleTopLevelConstant = true
class TestModuleConstant {
  Constant = true
  class Nested {
    Constant = true
  }
}
# Used in multiple-assigns constant test.
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
  
  it: "get top-level constants" when: {
    TestModuleTopLevelConstant is_not: nil
    TestModuleConstant Constant is: true
    TestModuleConstant Nested Constant is: true
  }
  it: "sets top-level constants" when: {
    TestModuleTopLevelConstant is_not: 'other
    TestModuleTopLevelConstant = 'other
    TestModuleTopLevelConstant is: 'other
  }
  it: "multiple-assigns top-level constants" when: {
    TestModuleConstantMultiA is: 1
    TestModuleConstantMultiB is: 2
  }
  it: "gets and sets local constants" when: {
    A = true
    A is: true
    A = false
    A is: false
  }
  it: "multiple-assigns local constants" when: {
    B, C = 1, 2
    B is: 1
    C is: 2
  }

}#/Module
