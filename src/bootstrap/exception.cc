#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Exception class methods
     */
    METHOD(class_method_Exception_new);

    /**
     * Exception instance methods
     */
    METHOD(method_Exception_raise);
    METHOD(method_Exception_message);

    /**
     * MethodNotFoundError instance methods
     */
    METHOD(method_MethodNotFoundError_method_name);
    METHOD(method_MethodNotFoundError_class);

    /**
     * IOError instance methods
     */
    METHOD(method_IOError_filename);
    METHOD(method_IOError_modes);

    void init_exception_classes()
    {
      ExceptionClass->def_class_method("new:", new NativeMethod("new:", class_method_Exception_new));

      ExceptionClass->def_method("raise!",
                                 new NativeMethod("raise!",
                                                  "Raises (throws) the Exception up the execution stack, in order to be caught.",
                                                  method_Exception_raise));

      ExceptionClass->def_method("message",
                                 new NativeMethod("message",
                                                  "Returns the message (should be a String) of the Exception",
                                                  method_Exception_message));

      MethodNotFoundErrorClass->def_method("method_name",
                                           new NativeMethod("method_name",
                                                            "Returns the name of the Method, that was not found.",
                                                            method_MethodNotFoundError_method_name));

      MethodNotFoundErrorClass->def_method("_class",
                                           new NativeMethod("_class",
                                                            "Returns the Class for which the Method wasn not found.",
                                                            method_MethodNotFoundError_class));

      IOErrorClass->def_method("filename",
                               new NativeMethod("filename",
                                                "Returns the filename for which an IOError occured.",
                                                method_IOError_filename));

      IOErrorClass->def_method("modes",
                               new NativeMethod("modes",
                                                "Returns the modes Array of the IOError.",
                                                method_IOError_modes));
    }

    /**
     * Exception class methods
     */
    FancyObject_p class_method_Exception_new(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      EXPECT_ARGS("Exception##new:", 1);
      string message = args[0]->to_s();
      return new FancyException(message);
    }


    /**
     * Exception instance methods
     */

    FancyObject_p method_Exception_raise(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(FancyException_p except = dynamic_cast<FancyException_p>(self)) {
        throw except;
      } else {
        cout << "DIDNT raise!" <<endl;
        return nil;
      }
    }

    FancyObject_p method_Exception_message(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
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

    FancyObject_p method_MethodNotFoundError_method_name(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return String::from_value(except->method_name());
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    FancyObject_p method_MethodNotFoundError_class(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return except->get_class();
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    /**
     * IOError instance methods
     */

    FancyObject_p method_IOError_filename(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(IOError_p except = dynamic_cast<IOError_p>(self)) {
        return String::from_value(except->filename());
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

    FancyObject_p method_IOError_modes(FancyObject_p self, FancyObject_p *args, int argc, Scope *scope)
    {
      if(IOError_p except = dynamic_cast<IOError_p>(self)) {
        return except->modes();
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

  }
}
