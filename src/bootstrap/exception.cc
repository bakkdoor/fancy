#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_exception_class()
    {
      ExceptionClass->def_class_method("new:", new NativeMethod("new:", class_method_Exception_new, 1));
      ExceptionClass->def_method("raise!", new NativeMethod("raise!", method_Exception_raise));
      ExceptionClass->def_method("message", new NativeMethod("message", method_Exception_message));
    }

    /**
     * Exception class methods
     */
    FancyObject_p class_method_Exception_new(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      EXPECT_ARGS("Exception##new:", 1);
      string message = args.front()->to_s();
      return new FancyException(message);
    }


    /**
     * Exception instance methods
     */

    FancyObject_p method_Exception_raise(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(FancyException_p except = dynamic_cast<FancyException_p>(self)) {
        throw except;
      } else {
        cout << "DIDNT raise!" <<endl;
        return nil;
      }
    }

    FancyObject_p method_Exception_message(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(FancyException_p except = dynamic_cast<FancyException_p>(self)) {
        return String::from_value(except->message());
      } else {
        cout << "DIDNT raise!" <<endl;
        return nil;
      }
    }

  }
}
