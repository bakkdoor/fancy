FancySpec describe: "Documentations" with: {
#   it: "should display the documentation for a method" when: {
#     documentation = "Array#each: iterates over its elements, calling a given block with each element."
#     Array method: "each:" . documentation: documentation
#     Array method: "each:" . documentation . should == documentation
#   }

#   it: "should define a documenation string for a class" when: {
#     class ClassWithDoc {
#       "This class has a documentation! Yay!"
#       def foo {
#         "bar!"
#       }
#     }
#     ClassWithDoc documentation should_not == ""
#     ClassWithDoc documentation should == "This class has a documentation! Yay!"
#   }

#   it: "should define a documenation string for a method" when: {
#     method = def foo {
#       "bar!"
#     }
#     method documentation should == "bar!"
#   }

#   it: "should have a documentation string for a method" when: {
#     Array method: "first" . documentation should_not be: |s| { s empty? }
#   }
}
