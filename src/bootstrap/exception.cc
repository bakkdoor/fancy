#include "includes.h"

namespace fancy {
  namespace bootstrap {

    void init_exception_classes()
    {
      /**
       * Exception class
       */

      DEF_CLASSMETHOD(ExceptionClass,
                      "new:",
                      "Exception constructor.",
                      new);

      DEF_METHOD(ExceptionClass,
                 "raise!",
                 "Raises (throws) the Exception up the execution stack, in order to be caught.",
                 raise);

      DEF_METHOD(ExceptionClass,
                 "message",
                 "Returns the message (should be a String) of the Exception",
                 message);

      /**
       * MethodNotFoundError class
       */

      DEF_METHOD(MethodNotFoundErrorClass,
                 "method_name",
                 "Returns the name of the Method, that was not found.",
                 method_name);

      DEF_METHOD(MethodNotFoundErrorClass,
                 "_class",
                 "Returns the Class for which the Method wasn not found.",
                 _class);
                 
                 
      /**
       * IOError class
       */
      
      DEF_METHOD(IOErrorClass,
                 "filename",
                 "Returns the filename for which an IOError occured.",
                 filename);

      DEF_METHOD(IOErrorClass,
                 "modes",
                 "Returns the modes Array of the IOError.",
                 modes);
    }

    /**
     * Exception class methods
     */

    CLASSMETHOD(ExceptionClass, new)
    {
      EXPECT_ARGS("Exception##new:", 1);
      string message = args[0]->to_s();
      return new FancyException(message);
    }


    /**
     * Exception instance methods
     */

    METHOD(ExceptionClass, raise)
    {
      if(FancyException_p except = dynamic_cast<FancyException_p>(self)) {
        throw except;
      } else {
        cout << "DIDNT raise!" <<endl;
        return nil;
      }
    }

    METHOD(ExceptionClass, message)
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

    METHOD(MethodNotFoundErrorClass, method_name)
    {
      if(MethodNotFoundError_p except = dynamic_cast<MethodNotFoundError_p>(self)) {
        return String::from_value(except->method_name());
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    METHOD(MethodNotFoundErrorClass, _class)
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

    METHOD(IOErrorClass, filename)
    {
      if(IOError_p except = dynamic_cast<IOError_p>(self)) {
        return String::from_value(except->filename());
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

    METHOD(IOErrorClass, modes)
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
