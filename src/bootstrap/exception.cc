#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_exception_classes()
    {
      ExceptionClass->def_class_method("new:", new NativeMethod("new:", class_method_Exception_new, 1));
      ExceptionClass->def_method("raise!", new NativeMethod("raise!", method_Exception_raise));
      ExceptionClass->def_method("message", new NativeMethod("message", method_Exception_message));

      MethodNotFoundErrorClass->def_method("method_name",
                                           new NativeMethod("method_name", method_MethodNotFoundError_method_name));
      MethodNotFoundErrorClass->def_method("_class",
                                           new NativeMethod("_class", method_MethodNotFoundError_class));
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
        errorln("Not a Exception!");
        return nil;
      }
    }
 

    /**
     * MethodNotFoundError instance methods
     */

    FancyObject_p method_MethodNotFoundError_method_name(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return String::from_value(except->method_name());
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    FancyObject_p method_MethodNotFoundError_class(FancyObject_p self, list<FancyObject_p> args, Scope *scope)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return except->get_class();
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

  }
}
