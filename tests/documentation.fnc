FancySpec describe: "DocStrings" with: |it| {
  it should: "display the docstring for a method" when: {
    docstring = "Array#each: iterates over its elements, calling a given block with each element.";
    Array method: "each:" . docstring: docstring;
    Array method: "each:" . docstring . should == docstring
  };

  it should: "define a documenation string for a class" when: {
    def class ClassWithDoc {
      "This class has a docstring! Yay!";
      def foo {
        "bar!"
      }
    };
    ClassWithDoc docstring should_not == "";
    ClassWithDoc docstring should == "This class has a docstring! Yay!"
  };

  it should: "define a documenation string for a method" when: {
    method = def foo {
      "bar!"
    };
    method docstring should == "bar!"
  };

  it should: "have a documentation string for a method" when: {
    Array method: "first" . docstring should_not be: |s| { s empty? }
  }
}
