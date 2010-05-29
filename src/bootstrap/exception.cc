#include "includes.h"

#include "../array.h"
#include "../string.h"
#include "../errors.h"

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

      DEF_CLASSMETHOD(IOErrorClass,
                      "message:filename:",
                      "Creates a new IOError Exception with a given message and filename.",
                      message__filename);

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
      if(FancyException* except = dynamic_cast<FancyException*>(self)) {
        throw except;
      } else {
        cout << "DIDNT raise!" <<endl;
        cout << "except is: " << self->to_s() << endl;
        return nil;
      }
    }

    METHOD(ExceptionClass, message)
    {
      if(FancyException* except = dynamic_cast<FancyException*>(self)) {
        return FancyString::from_value(except->message());
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
      if(MethodNotFoundError* except = dynamic_cast<MethodNotFoundError*>(self)) {
        return FancyString::from_value(except->method_name());
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    METHOD(MethodNotFoundErrorClass, _class)
    {
      if(MethodNotFoundError* except = dynamic_cast<MethodNotFoundError*>(self)) {
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
      if(IOError* except = dynamic_cast<IOError*>(self)) {
        return FancyString::from_value(except->filename());
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

    METHOD(IOErrorClass, modes)
    {
      if(IOError* except = dynamic_cast<IOError*>(self)) {
        return except->modes();
      } else {
        errorln("Not an IOError!");
        return nil;
      }
    }

    CLASSMETHOD(IOErrorClass, message__filename)
    {
      EXPECT_ARGS("IOError##message:filename::", 2);      
      return new IOError(args[0]->to_s(), args[1]->to_s());
    }

  }
}
