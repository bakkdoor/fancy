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

}#/Module
