FancySpec describe: Scope with: |it| {
  it should: "have the correct value for an identifier after defining it" when: {
    hello should_equal: nil;
    __current_scope__ define: "hello" value: 10;
    hello should_equal: 10;

    # note, that this code defines "foo" to be "bar" in the outer
    # scope. in this case, the scope surrounding the method definition
    # (and so in the context of self on which the method is defined)
    def self define_in_parent_scope {
      parent = __current_scope__ parent;
      { parent define: "foo" value: "bar" } if: parent
    };

    foo should_equal: nil;
    self define_in_parent_scope;
    foo should_equal: "bar"
  }
}
