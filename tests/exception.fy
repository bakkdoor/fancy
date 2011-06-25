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
  it: "raises an exception and catch it correctly" for: 'raise! when: {
    try {
      StdError new: "FAIL!" . raise!
      nil is == true # this is not occur
    } catch StdError => ex {
      ex message is == "FAIL!"
    }
  }

  it: "raises an exception and have the expected error message" for: 'raise! when: {
    {
      StdError new: "FAIL!" . raise!
    } raises: StdError with: |e| {
      e message is == "FAIL!"
    }

    {
      "FAIL, AGAIN!" raise!
    } raises: StdError with: |e| {
      e message is == "FAIL, AGAIN!"
    }
  }

  it: "raises an exception inside a method and catch it correctly" when: {
    f = Foo new
    f bar: "Don't raise here" . is == 'no_error
    try {
      f bar: 'error . is == 'no_error
    } catch StdError => e {
      e message is == "Some Error"
    }
  }

  # it: "raises a NoMethodError" when: {
  #   s = 'symbol
  #   try {
  #     s this_method_doesnt_exist!
  #     nil is == true # is not execute
  #   } catch NoMethodError => err {
  #     err for_class is == Symbol
  #     err method_name is == "this_method_doesnt_exist!"
  #   }
  # }

  it: "has access to variables in exception handlers defined in the surrounding scope" when: {
    var = 1234
    try {
      var wont_work!
    } catch NoMethodError => err {
      var is == 1234
    }
  }

  it: "always evaluates the finally clause" when: {
    set_in_finally = false
    try {
      x = 10 / 0 # ouch!
      "This is fail!" is == true # is not get here!
    } catch ZeroDivisionError => err {
      err message is == "divided by 0"
    } finally {
      # this part gets always run :)
      "It works!" is == "It works!"
      set_in_finally is == false
      set_in_finally = true
    }
    set_in_finally is == true
  }

  it: "raises a StdError when raising a String" for: 'raise! when: {
    msg = "A Custom Error!"
    {
      msg raise!
    } raises: StdError with: |e| {
      e message is == msg
    }
  }

  it: "raises and catch a custom exception correctly" for: 'raise! when: {
    class MyError : StdError{
      def initialize {
        initialize: "MyError message"
      }
    }

    try {
      MyError new raise!
      nil is == true # will fail
    } catch MyError => e {
      e message is == "MyError message"
    }
  }

  it: "restarts itself after being fixed in a catch clause" when: {
    y = 0
    x = 0
    try {
      x = 10 / y
    } catch ZeroDivisionError => e {
      y is == 0
      x is == 0
      y = 2
      retry
    }
    y is  == 2
    x is  == 5
  }

  it: "always executes the finally block when defined" when: {
    try {
      msg = "Reraise a new Exception :P"
      try {
        10 / 0 # ZeroDivisionError
      } finally {
        msg raise!
      }
    } catch StdError => e {
      e message is == msg
    }
  }
}
