#include "../../vendor/gc/include/gc.h"
#include "../../vendor/gc/include/gc_cpp.h"
#include "../../vendor/gc/include/gc_allocator.h"

#include "includes.h"

#include "../array.h"
#include "../string.h"
#include "../errors.h"

namespace fancy {
  namespace bootstrap {

    void init_error_classes()
    {
      /**
       * Exception class
       */

      DEF_METHOD(StdErrorClass,
                 "raise!",
                 "Raises (throws) the Exception up the execution stack, in order to be caught.",
                 raise);

      /**
       * MethodNotFoundError class
       */

      DEF_METHOD(MethodNotFoundErrorClass,
                 "method_name",
                 "Returns the name of the Method, that was not found.",
                 method_name);

      DEF_METHOD(MethodNotFoundErrorClass,
                 "for_class",
                 "Returns the Class for which the Method wasn not found.",
                 for_class);

      DEF_METHOD(MethodNotFoundErrorClass,
                 "message",
                 "Returns the error message.",
                 message_method_not_found);


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

      DEF_METHOD(IOErrorClass,
                 "message",
                 "Returns the error message.",
                 message_io_error);


      /* DivisionByZeroError */

      DEF_METHOD(DivisionByZeroErrorClass,
                 "message",
                 "Returns the error message.",
                 message_division_by_zero);

    }


    /**
     * Exception instance methods
     */

    METHOD(StdErrorClass, raise)
    {
      throw self;
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

    METHOD(MethodNotFoundErrorClass, for_class)
    {
      if(MethodNotFoundError* except = dynamic_cast<MethodNotFoundError*>(self)) {
        return except->for_class();
      } else {
        errorln("Not a MethodNotFoundError!");
        return nil;
      }
    }

    METHOD(MethodNotFoundErrorClass, message_method_not_found)
    {
      if(MethodNotFoundError* except = dynamic_cast<MethodNotFoundError*>(self)) {
        return FancyString::from_value(except->message());
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

    METHOD(IOErrorClass, message_io_error)
    {
      if(IOError* except = dynamic_cast<IOError*>(self)) {
        return FancyString::from_value(except->message());
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

    /* DivisionByZeroError */

    METHOD(DivisionByZeroErrorClass, message_division_by_zero)
    {
      if(DivisionByZeroError* except = dynamic_cast<DivisionByZeroError*>(self)) {
        return FancyString::from_value(except->message());
      } else {
        errorln("Not an DivisionByZeroError!");
        return nil;
      }
    }


  }
}
