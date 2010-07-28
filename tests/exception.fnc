def class Foo {
  def bar: x {
    (x == :error) . if_true: {
      Exception new: "Some Error" . raise!
    } else: {
      :no_error
    }
  }
};

FancySpec describe: Exception with: |it| {
  it should: "raise an exception and catch it correctly" when: {
    try {
      Exception new: "FAIL!" . raise!;
      nil should == true # this should not occur
    } catch Exception => ex {
      ex message should == "FAIL!"
    }
  };

  it should: "raise an exception inside a method and catch it correctly" when: {
    f = Foo new;
    f bar: "Don't raise here" . should == :no_error;
    try {
      f bar: :error . should == :no_error
    } catch Exception => e {
      e message should == "Some Error"
    }
  };

  it should: "raise a MethodNotFoundError" when: {
    s = :symbol;
    try {
      s this_method_doesnt_exist!;
      nil should == true # should not execute
    } catch MethodNotFoundError => err {
      err _class should == Symbol;
      err method_name should == "this_method_doesnt_exist!"
    }
  };

  it should: "have access to variables in exception handlers defined in the surrounding scope" when: {
    var = 1234;
    try {
      var wont_work!
    } catch MethodNotFoundError => err {
      var should == 1234
    }
  };

  it should: "always evaluate the finally clause" when: {
    try {
      x = 10 / 0; # ouch!
      "This should fail!" should == true # should not get here!
    } catch DivisionByZeroError => err {
      err message should == "Division by zero!"
    } finally {
      # this part gets always run :)
      "It works!" should == "It works!"
    }
  }

}
