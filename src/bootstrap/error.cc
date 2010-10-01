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

      DEF_METHOD(UnknownIdentifierErrorClass,
                 "to_s",
                 "Returns String representation of the error.",
                 to_s);
    }


    /**
     * Exception instance methods
     */

    METHOD(StdErrorClass, raise)
    {
      throw self;
    }

    METHOD(UnknownIdentifierErrorClass, to_s)
    {
      if(UnknownIdentifierError* e = dynamic_cast<UnknownIdentifierError*>(self))
        return FancyString::from_value(e->to_s());
      return nil;
    }
  }
}
