FancySpec describe: "Documentations" with: {
  it: "should display the documentation for a method" when: {
    documentation = "Array#each: iterates over its elements, calling a given block with each element."
    Array new method: "each:" . documentation: documentation
    Array new method: "each:" . documentation . docs first is == documentation
  }

  it: "should define a documenation string for a class and method" when: {
    class ClassWithDoc {
      "This class has a documentation! Yay!"
      def foo {
        "bar!"
        nil
      }
    }
    ClassWithDoc documentation should_not == ""
    ClassWithDoc documentation is == "This class has a documentation! Yay!"
    ClassWithDoc new method: 'foo . documentation docs is == ["bar!"]
  }

  it: "should have a documentation string for a method" when: {
    Array new method: "first" . documentation should_not be: 'nil?
  }
}
