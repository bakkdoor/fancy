#include "includes.h"

namespace fancy {
  namespace bootstrap {

    /**
     * Method instance methods
     */
    METHOD(Method__name);

    void init_method_class()
    {
      MethodClass->def_method("name",
                              new NativeMethod("name",
                                               "Returns the name of a Method as a String.",
                                               Method__name));
    }

    METHOD(Method__name)
    {
      if(Method_p method = dynamic_cast<Method_p>(self)) {
        return String::from_value(method->name());
      } else if(NativeMethod_p method = dynamic_cast<NativeMethod_p>(self)) {
        return String::from_value(method->_identifier);
      } else {
        return nil;
      }
    }
  }
}
