FancySpec describe: "rbx/examples" with: {

  def example: file should_output: expected {
    it: file when: {
      out = System pipe: ("rbx rbx/parser/test.rb rbx/examples/" ++ file ++ ".fy")
      out should == expected
    }
  }

  require: "rbx_examples"

}
