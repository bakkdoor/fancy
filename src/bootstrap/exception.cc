#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Exception class methods
     */
    METHOD(Exception_class__new);

    /**
     * Exception instance methods
     */
    METHOD(Exception__raise);
    METHOD(Exception__message);

    /**
     * MethodNotFoundError instance methods
     */
    METHOD(MethodNotFoundError__method_name);
    METHOD(MethodNotFoundError__class);

    /**
     * IOError instance methods
     */
    METHOD(IOError__filename);
    METHOD(IOError__modes);

    void init_exception_classes()
    {
      ExceptionClass->def_class_method("new:", new NativeMethod("new:", Exception_class__new));

      ExceptionClass->def_method("raise!",
                                 new NativeMethod("raise!",
                                                  "Raises (throws) the Exception up the execution stack, in order to be caught.",
                                                  Exception__raise));

      ExceptionClass->def_method("message",
                                 new NativeMethod("message",
                                                  "Returns the message (should be a String) of the Exception",
                                                  Exception__message));

      MethodNotFoundErrorClass->def_method("method_name",
                                           new NativeMethod("method_name",
                                                            "Returns the name of the Method, that was not found.",
                                                            MethodNotFoundError__method_name));

      MethodNotFoundErrorClass->def_method("_class",
                                           new NativeMethod("_class",
                                                            "Returns the Class for which the Method wasn not found.",
                                                            MethodNotFoundError__class));

      IOErrorClass->def_method("filename",
                               new NativeMethod("filename",
                                                "Returns the filename for which an IOError occured.",
                                                IOError__filename));

      IOErrorClass->def_method("modes",
                               new NativeMethod("modes",
                                                "Returns the modes Array of the IOError.",
                                                IOError__modes));
    }

    /**
     * Exception class methods
     */
    METHOD(Exception_class__new)
    {
      EXPECT_ARGS("Exception##new:", 1);
      string message = args[0]->to_s();
      return new FancyException(message);
    }


    /**
     * Exception instance methods
     */

    METHOD(Exception__raise)
    {
      if(FancyException_p except = dynamic_cast<FancyException_p>(self)) {
        throw except;
      } else {
        cout << "DIDNT raise!" <<endl;
        return nil;
      }
    }

    METHOD(Exception__message)
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

    METHOD(MethodNotFoundError__method_name)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return String::from_value(except->method_name());
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    METHOD(MethodNotFoundError__class)
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

    METHOD(IOError__filename)
    {
      if(IOError_p except = dynamic_cast<IOError_p>(self)) {
        return String::from_value(except->filename());
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

    METHOD(IOError__modes)
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
