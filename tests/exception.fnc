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
  it should: "raise an exception and rescue it correctly" when: {
    try {
      Exception new: "FAIL!" . raise!;
      nil should_equal: true # this should not occur
    } rescue Exception => ex {
      ex message should_equal: "FAIL!"
    }
  };

  it should: "raise an exception inside a method and rescue it correctly" when: {
    f = Foo new;
    f bar: "Don't raise here" . should_equal: :no_error;
    try {
      f bar: :error . should_equal: :no_error
    } rescue Exception => e {
      e message should_equal: "Some Error"
    }
  };

  it should: "raise a MethodNotFoundError" when: {
    s = :symbol;
    try {
      s this_method_doesnt_exist!;
      nil should_equal: true # should not execute
    } rescue MethodNotFoundError => err {
      err _class should_equal: Symbol;
      err method_name should_equal: "this_method_doesnt_exist!"
    }
  };

  it should: "have access to variables in exception handlers defined in the surrounding scope" when: {
    var = 1234;
    try {
      var wont_work!
    } rescue MethodNotFoundError => err {
      var should_equal: 1234
    }
  }
  
}
