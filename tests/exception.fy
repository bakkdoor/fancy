class Foo {
  def bar: x {
    (x == 'error) . if_true: {
      StdError new: "Some Error" . raise!
    } else: {
      'no_error
    }
  }
}

FancySpec describe: StdError with: {
  it: "should raise an exception and catch it correctly" for: 'raise! when: {
    try {
      StdError new: "FAIL!" . raise!
      nil should == true # this should not occur
    } catch StdError => ex {
      ex message should == "FAIL!"
    }
  }

  it: "should raise an exception inside a method and catch it correctly" when: {
    f = Foo new
    f bar: "Don't raise here" . should == 'no_error
    try {
      f bar: 'error . should == 'no_error
    } catch StdError => e {
      e message should == "Some Error"
    }
  }

  # it: "should raise a NoMethodError" when: {
  #   s = 'symbol
  #   try {
  #     s this_method_doesnt_exist!
  #     nil should == true # should not execute
  #   } catch NoMethodError => err {
  #     err for_class should == Symbol
  #     err method_name should == "this_method_doesnt_exist!"
  #   }
  # }

  it: "should have access to variables in exception handlers defined in the surrounding scope" when: {
    var = 1234
    try {
      var wont_work!
    } catch NoMethodError => err {
      var should == 1234
    }
  }

  it: "should always evaluate the finally clause" when: {
    try {
      x = 10 / 0 # ouch!
      "This should fail!" should == true # should not get here!
    } catch ZeroDivisionError => err {
      err message should == "divided by 0"
    } finally {
      # this part gets always run :)
      "It works!" should == "It works!"
    }
  }

  it: "should raise a StdError when raising a String" for: 'raise! when: {
    msg = "A Custom Error!"
    try {
      msg raise!
      msg should_not == msg # this should not get executed
    } catch StdError => e {
      e message should == msg
    }
  }

  it: "should raise and catch a custom exception correctly" for: 'raise! when: {
    class MyError : StdError{
      def initialize {
        initialize: "MyError message"
      }
    }

    try {
      MyError new raise!
      nil should == true # will fail
    } catch MyError => e {
      e message should == "MyError message"
    }
  }

  it: "should restart itself after being fixed in a catch clause" when: {
    y = 0
    x = 0
    try {
      x = 10 / y
    } catch ZeroDivisionError => e {
      y should == 0
      x should == 0
      y = 2
      retry
    }
    y should  == 2
    x should  == 5
  }

  it: "should always execute the finally block when defined" when: {
    try {
      msg = "Reraise a new Exception :P"
      try {
        10 / 0 # ZeroDivisionError
      } finally {
        msg raise!
      }
    } catch StdError => e {
      e message should == msg
    }
  }
}
