FancySpec describe: "Documentations" with: {
  it: "displays the documentation for a method" when: {
    documentation = "Array#each: iterates over its elements, calling a given block with each element."
    Array new method: "each:" . documentation: documentation
    Array new method: "each:" . documentation . docs first is: documentation
  }

  it: "defines a documenation string for a class and method" when: {
    class ClassWithDoc {
      "This class has a documentation! Yay!"
      def foo {
        "bar!"
        nil
      }
    }
    ClassWithDoc documentation to_s is_not: ""
    ClassWithDoc documentation to_s is: "This class has a documentation! Yay!"
    ClassWithDoc new method: 'foo . documentation docs is: ["bar!"]
  }

  it: "has a documentation string for a method" when: {
    Array new method: "first" . documentation is_not be: 'nil?
  }
}
